"""
J. Fliege, L. M. Graña Drummond, and B. F. Svaiter, "Newton's Method for Multiobjective Optimization," SIAM Journal on Optimization, vol. 20, no. 2, pp. 602-626, 2009. DOI: 10.1137/08071692X.
"""

# ------------------------- FDS -------------------------
"""
    FDS(n::Int = 5)

Problem characteristics summary:
- `n` variables (default: 5)
- 3 objectives
- Objectives:
    f₁(x) = (1/n²) ∑ᵢ i(xᵢ - i)⁴
    f₂(x) = exp(∑ᵢ xᵢ/n) + ||x||²
    f₃(x) = (1/(n(n+1))) ∑ᵢ i(n-i+1)exp(-xᵢ)
- Bounds: [-2, 2] for each variable
- Convexity: strictly convex for all objectives
"""

function FDS(n::Int = 5)
    n >= 1 || throw(ArgumentError("n must be at least 1 for FDS"))
    meta = META["FDS"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * (x[i] - T(i))^4
        end
        return sum_val / (T(n)^2)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x = zero(T)
        norm2 = zero(T)
        for i in 1:n
            sum_x += x[i]
            norm2 += x[i]^2
        end
        return exp(sum_x / T(n)) + norm2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * T(n - i + 1) * exp(-x[i])
        end
        return sum_val / (T(n) * T(n + 1))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = T(4) * T(i) * (x[i] - T(i))^3 / (T(n)^2)
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x = zero(T)
        for i in 1:n
            sum_x += x[i]
        end
        exp_term = exp(sum_x / T(n))
        for i in 1:n
            grad[i] = exp_term / T(n) + T(2) * x[i]
        end
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = -T(i) * T(n - i + 1) * exp(-x[i]) / (T(n) * T(n + 1))
        end
        return grad
    end

    bounds = (fill(-2.0, n), fill(2.0, n))

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = bounds,
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end