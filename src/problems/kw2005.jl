"""
I.Y. Kim, O.L. de Weck, "Adaptive weighted-sum method for bi-objective optimization: Pareto front generation," 
Structural and Multidisciplinary Optimization, vol. 29, no. 2, pp. 149-158, 2005.
DOI: 10.1007/s00158-004-0465-1
"""

# ------------------------- KW2 -------------------------
"""
    KW2()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = -3(1-x₁)²exp(-x₁²-(x₂+1)²) + 10(x₁/5-x₁³-x₂⁵)exp(-x₁²-x₂²) + 3exp(-(x₁+2)²-x₂²) - 0.5(2x₁+x₂)
    f₂(x) = -3(1+x₂)²exp(-x₂²-(1-x₁)²) + 10(-x₂/5+x₂³+x₁⁵)exp(-x₁²-x₂²) + 3exp(-(2-x₂)²-x₁²)
- Bounds: [-3, 3] for all variables
- Convexity: non-convex for both objectives
"""
function KW2()
    meta = META["KW2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        term1 = -T(3) * (one(T) - x[1])^2 * exp(-x[1]^2 - (x[2] + one(T))^2)
        term2 = T(10) * (x[1] / T(5) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2)
        term3 = T(3) * exp(-(x[1] + T(2))^2 - x[2]^2)
        term4 = -T(0.5) * (T(2) * x[1] + x[2])
        return term1 + term2 + term3 + term4
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        term1 = -T(3) * (one(T) + x[2])^2 * exp(-x[2]^2 - (one(T) - x[1])^2)
        term2 = T(10) * (-x[2] / T(5) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2)
        term3 = T(3) * exp(-(T(2) - x[2])^2 - x[1]^2)
        return term1 + term2 + term3
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(6) * (one(T) - x[1]) * exp(-x[1]^2 - (x[2] + one(T))^2) +
                  T(6) * (one(T) - x[1])^2 * exp(-x[1]^2 - (x[2] + one(T))^2) * x[1] +
                  T(10) * (one(T) / T(5) - T(3) * x[1]^2) * exp(-x[1]^2 - x[2]^2) -
                  T(20) * (x[1] / T(5) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2) * x[1] -
                  T(6) * exp(-(x[1] + T(2))^2 - x[2]^2) * (x[1] + T(2)) - one(T)

        grad[2] = T(6) * (one(T) - x[1])^2 * exp(-x[1]^2 - (x[2] + one(T))^2) * (x[2] + one(T)) -
                  T(50) * x[2]^4 * exp(-x[1]^2 - x[2]^2) -
                  T(10) * (x[1] / T(5) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2) * T(2) * x[2] -
                  T(6) * exp(-(x[1] + T(2))^2 - x[2]^2) * x[2] - T(0.5)

        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -T(6) * (one(T) + x[2])^2 * exp(-x[2]^2 - (one(T) - x[1])^2) * (one(T) - x[1]) +
                  T(50) * x[1]^4 * exp(-x[1]^2 - x[2]^2) -
                  T(20) * (-x[2] / T(5) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2) * x[1] -
                  T(6) * exp(-(T(2) - x[2])^2 - x[1]^2) * x[1]

        grad[2] = -T(6) * (one(T) + x[2]) * exp(-x[2]^2 - (one(T) - x[1])^2) +
                  T(6) * (one(T) + x[2])^2 * exp(-x[2]^2 - (one(T) - x[1])^2) * x[2] +
                  T(10) * (-one(T) / T(5) + T(3) * x[2]^2) * exp(-x[1]^2 - x[2]^2) -
                  T(20) * (-x[2] / T(5) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2) * x[2] +
                  T(6) * exp(-(T(2) - x[2])^2 - x[1]^2) * (T(2) - x[2])

        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-3.0, n), fill(3.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end