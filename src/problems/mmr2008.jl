"""
    MMR1, MMR2, MMR3, MMR4

Test problems from:
E. Miglierina, E. Molho, M.C. Recchioni (2008),
"Box-constrained multi-objective optimization: A gradient-like method without “a priori” scalarization",
European Journal of Operational Research, 188(3), 662-682.
https://doi.org/10.1016/j.ejor.2007.05.015
"""

# ------------------------- MMR1 -------------------------
"""
    MMR1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = (2 - 0.8exp(-((x₂ - 0.6) / 0.4)²) - exp(-((x₂ - 0.2) / 0.04)²)) / x₁
- Bounds: x₁ in [0.1, 1.0], x₂ in [0.0, 1.0]
- Convexity: [convex, non-convex]
"""
function MMR1()
    meta = META["MMR1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = exp(-((x[2] - T(0.6)) / T(0.4))^2)
        t2 = exp(-((x[2] - T(0.2)) / T(0.04))^2)
        g = T(2) - T(0.8) * t1 - t2
        return g / x[1]
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T)
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = exp(-((x[2] - T(0.6)) / T(0.4))^2)
        t2 = exp(-((x[2] - T(0.2)) / T(0.04))^2)
        g = T(2) - T(0.8) * t1 - t2
        grad[1] = -g / x[1]^2
        grad[2] = (T(10) * t1 * (x[2] - T(0.6)) + T(1250) * t2 * (x[2] - T(0.2))) / x[1]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = ([0.1, 0.0], [1.0, 1.0]),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MMR2 -------------------------
"""
    MMR2()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = (1 - (x₁/a)² - (x₁/a)sin(8πx₁))a, where a = 1 + 10x₂
- Bounds: [0, 1] for all variables
- Convexity: [convex, non-convex]
"""
function MMR2()
    meta = META["MMR2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) + T(10) * x[2]
        faux = x[1] / a
        angle = T(8) * T(π) * x[1]
        return (one(T) - faux^2 - faux * sin(angle)) * a
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T)
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) + T(10) * x[2]
        faux = x[1] / a
        angle = T(8) * T(π) * x[1]
        sin_angle = sin(angle)
        cos_angle = cos(angle)

        grad[1] = a * (
            -T(2) * faux / a -
            sin_angle / a -
            T(8) * T(π) * faux * cos_angle
        )
        grad[2] = T(10) * (one(T) - faux^2 - faux * sin_angle) +
                  a * (T(20) * faux * x[1] / a^2 + T(10) * x[1] * sin_angle / a^2)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MMR3 -------------------------
"""
    MMR3()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁³
    f₂(x) = (x₂ - x₁)³
- Bounds: [-1, 1] for all variables
- Convexity: non-convex for both objectives
"""
function MMR3()
    meta = META["MMR3"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^3
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[2] - x[1])^3
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(3) * x[1]^2
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t = (x[2] - x[1])^2
        grad[1] = -T(3) * t
        grad[2] = T(3) * t
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MMR4 -------------------------
"""
    MMR4()

Problem characteristics summary:
- 3 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁ - 2x₂ - x₃ - 36 / (2x₁ + x₂ + 2x₃ + 1)
    f₂(x) = -3x₁ + x₂ - x₃
- Bounds: [0, 4] for all variables
- Convexity: [non-convex, convex]
"""
function MMR4()
    meta = META["MMR4"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        den = T(2) * x[1] + x[2] + T(2) * x[3] + one(T)
        return x[1] - T(2) * x[2] - x[3] - T(36) / den
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return -T(3) * x[1] + x[2] - x[3]
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t = (T(2) * x[1] + x[2] + T(2) * x[3] + one(T))^2
        grad[1] = one(T) + T(72) / t
        grad[2] = -T(2) + T(36) / t
        grad[3] = -one(T) + T(72) / t
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -T(3)
        grad[2] = one(T)
        grad[3] = -one(T)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (zeros(n), fill(4.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end