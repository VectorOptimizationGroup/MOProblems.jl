"""
H. Ishibuchi and T. Murata, "A multi-objective genetic local search algorithm and its application to flowshop scheduling," in IEEE Transactions on Systems, Man, and Cybernetics, Part C (Applications and Reviews), vol. 28, no. 3, pp. 392-403, Aug. 1998, doi: 10.1109/5326.704576.
"""

# ------------------------- IM1 -------------------------
"""
    IM1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 2.0 * sqrt(x₁)
    f₂(x) = x₁ * (1.0 - x₂) + 5.0
- Bounds: x₁ ∈ [1.0, 4.0], x₂ ∈ [1.0, 2.0]
"""
function IM1()
    meta = META["IM1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(2) * sqrt(x[1])
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1] * (one(T) - x[2]) + T(5)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T) / sqrt(x[1])
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T) - x[2]
        grad[2] = -x[1]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = ([1.0, 1.0], [4.0, 2.0]),
        jacobian = (df1_dx, df2_dx),
    )
end