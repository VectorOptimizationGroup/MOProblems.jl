"""
Tan, K. C., Khor, E. F., Lee, T. H., & Yang, Y. J. (2003).
A Tabu-Based Exploratory Evolutionary Algorithm for Multiobjective Optimization.
Artificial Intelligence Review, 19(3), 231-260. https://doi.org/10.1023/A:1022863019997
"""

# ------------------------- TKLY1 -------------------------
"""
    TKLY1()

Problem characteristics summary:
- 4 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = A(x₂)A(x₃)A(x₄) / x₁
    where A(z) = 2 - exp(-((z - 0.1) / 0.004)²) - 0.8exp(-((z - 0.9) / 0.4)²)
- Bounds: x₁ in [0.1, 1], x₂, x₃, x₄ in [0, 1]
"""
function TKLY1()
    meta = META["TKLY1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    A = function (z::T) where {T <: AbstractFloat}
        u1 = (z - T(0.1)) / T(0.004)
        u2 = (z - T(0.9)) / T(0.4)
        return T(2) - exp(-u1^2) - T(0.8) * exp(-u2^2)
    end

    dA = function (z::T) where {T <: AbstractFloat}
        u1 = (z - T(0.1)) / T(0.004)
        u2 = (z - T(0.9)) / T(0.4)
        return T(500) * exp(-u1^2) * u1 + T(4) * exp(-u2^2) * u2
    end

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return A(x[2]) * A(x[3]) * A(x[4]) / x[1]
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T)
        grad[2] = zero(T)
        grad[3] = zero(T)
        grad[4] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a2 = A(x[2])
        a3 = A(x[3])
        a4 = A(x[4])
        numerator = a2 * a3 * a4
        grad[1] = -numerator / x[1]^2
        grad[2] = dA(x[2]) * a3 * a4 / x[1]
        grad[3] = a2 * dA(x[3]) * a4 / x[1]
        grad[4] = a2 * a3 * dA(x[4]) / x[1]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = ([0.1, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0]),
        jacobian = (df1_dx, df2_dx),
    )
end
