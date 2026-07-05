"""
Y. Jin, M. Olhofer and B. Sendhoff, "Dynamic Weighted Aggregation for evolutionary multi-objective optimization: why does it work and how?," Proceedings of the 3rd Annual Conference on Genetic and Evolutionary Computation (GECCO'01), San Francisco, California, 2001, pp. 1042-1049.
"""

# ------------------------- JOS1 -------------------------
"""
    JOS1(n::Int = 2)

Problem characteristics summary:
- `n` variables (default: 2)
- 2 objectives
- Objectives:
    f₁(x) = (1/n) * Σ(x[i]²) = average of squared variables
    f₂(x) = (1/n) * Σ((x[i] - 2.0)²) = average of squared differences from 2.0
- Bounds: [-100, 100] for all variables
- Convexity: strictly convex for both objectives
"""

function JOS1(n::Int = 2)
    n >= 1 || throw(ArgumentError("n must be at least 1 for JOS1"))
    meta = META["JOS1"]
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_squares = zero(T)
        for i in 1:n
            sum_squares += x[i]^2
        end
        return sum_squares / T(n)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_squares = zero(T)
        for i in 1:n
            sum_squares += (x[i] - T(2))^2
        end
        return sum_squares / T(n)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = T(2) * x[i] / T(n)
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = T(2) * (x[i] - T(2)) / T(n)
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------------------------------------------------
# The JOS2, JOS3 are the same as ZDT1 and ZDT2, respectively.
# ------------------------------------------------------------------

# ------------------------- JOS4 -------------------------
"""
    JOS4()

Problem characteristics summary:
- 20 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = (1 + 9*sum(x[2:n])/(n-1)) * (1 - (x₁/faux)^0.25 - (x₁/faux)^4)
    where faux = 1 + 9*sum(x[2:n])/(n-1)
- Bounds: [0.01, 1.0] for all variables
- Convexity: non-convex for both objectives
"""
function JOS4()
    meta = META["JOS4"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x2n = zero(T)
        for i in 2:n
            sum_x2n += x[i]
        end
        faux = one(T) + T(9) * sum_x2n / T(n - 1)
        t = x[1] / faux
        return faux * (one(T) - t^T(0.25) - t^T(4))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x2n = zero(T)
        for i in 2:n
            sum_x2n += x[i]
        end
        faux = one(T) + T(9) * sum_x2n / T(n - 1)
        t = x[1] / faux

        grad[1] = -T(0.25) * t^T(-0.75) - T(4) * t^T(3)
        for i in 2:n
            grad[i] = T(9) / T(n - 1) * (one(T) - T(0.75) * t^T(0.25) + T(3) * t^T(4))
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(0.01, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end