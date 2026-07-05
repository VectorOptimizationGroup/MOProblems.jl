"""
    SP1()

Two-objective problem from Sefrioui and Perlaux (2000).

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = (x₁ - 1)² + (x₁ - x₂)²
    f₂(x) = (x₂ - 3)² + (x₁ - x₂)²
- Bounds: [-100, 100] for all variables

Reference:
Sefrioui, M., & Perlaux, J. (2000). Nash genetic algorithms: examples and applications.
In Proceedings of CEC 2000, 509-516. DOI: 10.1109/CEC.2000.870339.
"""
function SP1()
    meta = META["SP1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - one(T))^2 + (x[1] - x[2])^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[2] - T(3))^2 + (x[1] - x[2])^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - one(T)) + T(2) * (x[1] - x[2])
        grad[2] = -T(2) * (x[1] - x[2])
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - x[2])
        grad[2] = T(2) * (x[2] - T(3)) - T(2) * (x[1] - x[2])
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end
