"""
E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. DOI: 10.1162/106365600568202
"""

# ZDT1

"""
    ZDT1(n::Int = 30)

Problem characteristics summary:
- n variables (default: 30)
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = g(x)(1 - √(f₁(x) / g(x)))
- Definitions:
    g(x) = 1 + 9∑ᵢ₌₂ⁿxᵢ / (n - 1)
- Bounds: [0, 1] for all variables
- Pareto front: convex and continuous, with f₂ = 1 - √f₁
- Convexity: [convex, non-convex]
"""
function ZDT1(n::Int = 30)
    n >= 2 || throw(ArgumentError("n must be at least 2 for ZDT1"))
    meta = META["ZDT1"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for i in 2:n
            s += x[i]
        end
        return one(T) + T(9) * s / T(n - 1)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        return gx * (one(T) - sqrt(x[1] / gx))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        sqrt_ratio = sqrt(x[1] / gx)
        grad[1] = -T(0.5) / sqrt_ratio
        dg_dxi = T(9) / T(n - 1)
        @inbounds for i in 2:n
            grad[i] = dg_dxi * (one(T) - T(0.5) * sqrt_ratio)
        end
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end


# ZDT2

"""
    ZDT2(n::Int = 30)

Problem characteristics summary:
- n variables (default: 30)
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = g(x)(1 - (f₁(x) / g(x))²)
- Definitions:
    g(x) = 1 + 9∑ᵢ₌₂ⁿxᵢ / (n - 1)
- Bounds: [0, 1] for all variables
- Pareto front: non-convex and continuous, with f₂ = 1 - f₁²
- Convexity: [convex, non-convex]
"""
function ZDT2(n::Int = 30)
    n >= 2 || throw(ArgumentError("n must be at least 2 for ZDT2"))
    meta = META["ZDT2"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for i in 2:n
            s += x[i]
        end
        return one(T) + T(9) * s / T(n - 1)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        return gx * (one(T) - (x[1] / gx)^2)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        ratio = x[1] / gx
        grad[1] = -T(2) * ratio
        dg_dxi = T(9) / T(n - 1)
        @inbounds for i in 2:n
            grad[i] = dg_dxi * (one(T) + ratio^2)
        end
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end


# ZDT3

"""
    ZDT3(n::Int = 30)

Problem characteristics summary:
- n variables (default: 30)
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = g(x)(1 - √(f₁(x) / g(x)) - (f₁(x) / g(x))sin(10πf₁(x)))
- Definitions:
    g(x) = 1 + 9∑ᵢ₌₂ⁿxᵢ / (n - 1)
- Bounds: [0, 1] for all variables
- Pareto front: discontinuous
- Convexity: [convex, non-convex]
"""
function ZDT3(n::Int = 30)
    n >= 2 || throw(ArgumentError("n must be at least 2 for ZDT3"))
    meta = META["ZDT3"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for i in 2:n
            s += x[i]
        end
        return one(T) + T(9) * s / T(n - 1)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        ratio = x[1] / gx
        return gx * (one(T) - sqrt(ratio) - ratio * sin(T(10) * T(π) * x[1]))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        ratio = x[1] / gx
        sqrt_ratio = sqrt(ratio)
        angle = T(10) * T(π) * x[1]
        grad[1] = -T(0.5) / sqrt_ratio - sin(angle) - T(10) * T(π) * x[1] * cos(angle)
        dg_dxi = T(9) / T(n - 1)
        @inbounds for i in 2:n
            grad[i] = dg_dxi * (one(T) - T(0.5) * sqrt_ratio)
        end
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end


# ZDT4

"""
    ZDT4(n::Int = 10)

Problem characteristics summary:
- n variables (default: 10)
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = g(x)(1 - √(f₁(x) / g(x)))
- Definitions:
    g(x) = 1 + 10(n - 1) + ∑ᵢ₌₂ⁿ(xᵢ² - 10cos(4πxᵢ))
- Bounds: x₁ ∈ [0, 1], xᵢ ∈ [-5, 5] for i ≥ 2
- Pareto front: convex and continuous, with f₂ = 1 - √f₁
- Convexity: [convex, non-convex]
"""
function ZDT4(n::Int = 10)
    n >= 2 || throw(ArgumentError("n must be at least 2 for ZDT4"))
    meta = META["ZDT4"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for i in 2:n
            s += x[i]^2 - T(10) * cos(T(4) * T(π) * x[i])
        end
        return one(T) + T(10) * T(n - 1) + s
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        return gx * (one(T) - sqrt(x[1] / gx))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        gx = g(x)
        sqrt_ratio = sqrt(x[1] / gx)
        grad[1] = -T(0.5) / sqrt_ratio
        @inbounds for i in 2:n
            dg_dxi = T(2) * x[i] + T(40) * T(π) * sin(T(4) * T(π) * x[i])
            grad[i] = dg_dxi * (one(T) - T(0.5) * sqrt_ratio)
        end
        return grad
    end

    lower = fill(-5.0, n)
    upper = fill(5.0, n)
    lower[1] = 0.0
    upper[1] = 1.0

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (lower, upper),
        jacobian = (df1_dx, df2_dx),
    )
end


# ZDT6

"""
    ZDT6(n::Int = 10)

Problem characteristics summary:
- n variables (default: 10)
- 2 objectives
- Objectives:
    f₁(x) = 1 - exp(-4x₁)sin⁶(6πx₁)
    f₂(x) = g(x)(1 - (f₁(x) / g(x))²)
- Definitions:
    g(x) = 1 + 9(∑ᵢ₌₂ⁿxᵢ / (n - 1))⁰⋅²⁵
- Bounds: [0, 1] for all variables
- Pareto front: non-uniform
- Convexity: non-convex for both objectives
"""
function ZDT6(n::Int = 10)
    n >= 2 || throw(ArgumentError("n must be at least 2 for ZDT6"))
    meta = META["ZDT6"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return one(T) - exp(-T(4) * x[1]) * sin(T(6) * T(π) * x[1])^6
    end

    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for i in 2:n
            s += x[i]
        end
        return one(T) + T(9) * (s / T(n - 1))^T(0.25)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        f1x = f1(x)
        gx = g(x)
        return gx * (one(T) - (f1x / gx)^2)
    end

    df1_dx1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        angle = T(6) * T(π) * x[1]
        sin_term = sin(angle)
        cos_term = cos(angle)
        exp_term = exp(-T(4) * x[1])
        return T(4) * exp_term * sin_term^6 - T(36) * T(π) * exp_term * sin_term^5 * cos_term
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = df1_dx1(x)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        f1x = f1(x)
        gx = g(x)
        ratio = f1x / gx
        grad[1] = -T(2) * ratio * df1_dx1(x)

        sum_x = zero(T)
        @inbounds for i in 2:n
            sum_x += x[i]
        end

        if sum_x > zero(T)
            mean_x = sum_x / T(n - 1)
            dg_dxi = T(9) * T(0.25) * mean_x^(-T(0.75)) / T(n - 1)
        else
            dg_dxi = zero(T)
        end

        term = one(T) + ratio^2
        @inbounds for i in 2:n
            grad[i] = dg_dxi * term
        end
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end