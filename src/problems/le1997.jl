"""
J. Lis and A. E. Eiben, "A multi-sexual genetic algorithm for multiobjective optimization," 
Proceedings of 1997 IEEE International Conference on Evolutionary Computation (ICEC '97), 
Indianapolis, IN, USA, 1997, pp. 59-64, doi: 10.1109/ICEC.1997.592269.
"""

# ------------------------- LE1 -------------------------
"""
    LE1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = (x₁² + x₂²)^0.125
    f₂(x) = ((x₁ - 0.5)² + (x₂ - 0.5)²)^0.25
- Bounds: [1, 10] for all variables
"""
function LE1()
    meta = META["LE1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1]^2 + x[2]^2)^T(0.125)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return ((x[1] - T(0.5))^2 + (x[2] - T(0.5))^2)^T(0.25)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t = T(0.25) * (x[1]^2 + x[2]^2)^T(-0.875)
        grad[1] = x[1] * t
        grad[2] = x[2] * t
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t = T(0.5) * ((x[1] - T(0.5))^2 + (x[2] - T(0.5))^2)^T(-0.75)
        grad[1] = (x[1] - T(0.5)) * t
        grad[2] = (x[2] - T(0.5)) * t
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(1.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end