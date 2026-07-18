"""
C. M. Fonseca and P. J. Fleming, "An Overview of Evolutionary Algorithms in Multiobjective Optimization," Evolutionary Computation, vol. 3, no. 1, pp. 1-16, March 1995. DOI: 10.1162/evco.1995.3.1.1.
"""

# ------------------------- FF1 -------------------------
"""
    FF1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 1 - exp(-(x₁ - 1)² - (x₂ + 1)²)
    f₂(x) = 1 - exp(-(x₁ + 1)² - (x₂ - 1)²)
- Bounds: [-1, 1] for each variable
"""
function FF1()
    meta = META["FF1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return one(T) - exp(-((x[1] - one(T))^2 + (x[2] + one(T))^2))
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return one(T) - exp(-((x[1] + one(T))^2 + (x[2] - one(T))^2))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp_term = exp(-((x[1] - one(T))^2 + (x[2] + one(T))^2))
        grad[1] = T(2) * (x[1] - one(T)) * exp_term
        grad[2] = T(2) * (x[2] + one(T)) * exp_term
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp_term = exp(-((x[1] + one(T))^2 + (x[2] - one(T))^2))
        grad[1] = T(2) * (x[1] + one(T)) * exp_term
        grad[2] = T(2) * (x[2] - one(T)) * exp_term
        return grad
    end

    bounds = (fill(-1.0, n), fill(1.0, n))

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = bounds,
        jacobian = (df1_dx, df2_dx),
    )
end