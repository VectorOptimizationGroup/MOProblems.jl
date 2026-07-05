"""
Schütze, O., Laumanns, M., Coello Coello, C.A., Dellnitz, M., Talbi, E.-G. (2008).
Convergence of stochastic search algorithms to finite size pareto set approximations.
Journal of Global Optimization 41(4): 559-577. https://doi.org/10.1007/s10898-007-9265-7
"""

# ------------------------- SLCDT1 -------------------------
"""
    SLCDT1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 0.5(√(1 + (x₁ + x₂)²) + √(1 + (x₁ - x₂)²) + x₁ - x₂) + 0.85exp(-(x₁ + x₂)²)
    f₂(x) = 0.5(√(1 + (x₁ + x₂)²) + √(1 + (x₁ - x₂)²) - x₁ + x₂) + 0.85exp(-(x₁ + x₂)²)
- Bounds: [-1.5, 1.5] for all variables
- Convexity: non-convex for both objectives
"""
function SLCDT1()
    meta = META["SLCDT1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = x[1] + x[2]
        d = x[1] - x[2]
        return T(0.5) * (sqrt(one(T) + s^2) + sqrt(one(T) + d^2) + x[1] - x[2]) +
               T(0.85) * exp(-s^2)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = x[1] + x[2]
        d = x[1] - x[2]
        return T(0.5) * (sqrt(one(T) + s^2) + sqrt(one(T) + d^2) - x[1] + x[2]) +
               T(0.85) * exp(-s^2)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        s = x[1] + x[2]
        d = x[1] - x[2]
        t1 = s / sqrt(one(T) + s^2)
        t2 = d / sqrt(one(T) + d^2)
        common = -T(1.7) * s * exp(-s^2)
        grad[1] = T(0.5) * (t1 + t2 + one(T)) + common
        grad[2] = T(0.5) * (t1 - t2 - one(T)) + common
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        s = x[1] + x[2]
        d = x[1] - x[2]
        t1 = s / sqrt(one(T) + s^2)
        t2 = d / sqrt(one(T) + d^2)
        common = -T(1.7) * s * exp(-s^2)
        grad[1] = T(0.5) * (t1 + t2 - one(T)) + common
        grad[2] = T(0.5) * (t1 - t2 + one(T)) + common
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-1.5, n), fill(1.5, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- SLCDT2 -------------------------
"""
    SLCDT2()

Problem characteristics summary:
- 10 variables
- 3 objectives
- Objectives:
    f₁(x) = (x₁ - 1)⁴ + ∑ᵢ₌₂ⁿ(xᵢ - 1)²
    f₂(x) = (x₂ + 1)⁴ + ∑ᵢ≠₂(xᵢ + 1)²
    f₃(x) = (x₃ - 1)⁴ + ∑ᵢ≠₃(xᵢ - (-1)ⁱ⁺¹)²
- Bounds: [-1, 1] for all variables
- Convexity: non-convex for all objectives
"""
function SLCDT2()
    meta = META["SLCDT2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = (x[1] - one(T))^4
        @inbounds for i in 2:n
            s += (x[i] - one(T))^2
        end
        return s
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = (x[2] + one(T))^4
        @inbounds for i in 1:n
            if i != 2
                s += (x[i] + one(T))^2
            end
        end
        return s
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = (x[3] - one(T))^4
        @inbounds for i in 1:n
            if i != 3
                alt = isodd(i) ? one(T) : -one(T)
                s += (x[i] - alt)^2
            end
        end
        return s
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(4) * (x[1] - one(T))^3
        @inbounds for i in 2:n
            grad[i] = T(2) * (x[i] - one(T))
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        @inbounds for i in 1:n
            if i == 2
                grad[i] = T(4) * (x[i] + one(T))^3
            else
                grad[i] = T(2) * (x[i] + one(T))
            end
        end
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        @inbounds for i in 1:n
            if i == 3
                grad[i] = T(4) * (x[i] - one(T))^3
            else
                alt = isodd(i) ? one(T) : -one(T)
                grad[i] = T(2) * (x[i] - alt)
            end
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end
