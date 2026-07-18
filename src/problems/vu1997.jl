"""
Valenzuela-Rendón, M., & Uresti-Charre, E. (1997).
A nongenerational genetic algorithm for multiobjective optimization.
Proceedings of the 7th International Conference on Genetic Algorithms, 658-665.

Nota: As expressões explícitas usadas aqui foram extraídas do compêndio de Huband, S., Hingston, P.,
Barone, L., & While, L. (2006). "A review of multiobjective test problems and a scalable test
problem toolkit," IEEE Transactions on Evolutionary Computation, 10(5), 477-506.
https://doi.org/10.1109/TEVC.2005.861417, pois o texto original não apresenta as fórmulas de maneira
verificável.
"""

# ------------------------- VU1 -------------------------
"""
    VU1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 1 / (x₁² + x₂² + 1)
    f₂(x) = x₁² + 3x₂² + 1
- Bounds: [-3, 3] for all variables
"""
function VU1()
    meta = META["VU1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return one(T) / (x[1]^2 + x[2]^2 + one(T))
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + T(3) * x[2]^2 + one(T)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        den = x[1]^2 + x[2]^2 + one(T)
        coeff = -T(2) / den^2
        grad[1] = coeff * x[1]
        grad[2] = coeff * x[2]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = T(6) * x[2]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-3.0, n), fill(3.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- VU2 -------------------------
"""
    VU2()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁ + x₂ + 1
    f₂(x) = x₁² + 2x₂ - 1
- Bounds: [-3, 3] for all variables
"""
function VU2()
    meta = META["VU2"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1] + x[2] + one(T)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + T(2) * x[2] - one(T)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T)
        grad[2] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = T(2)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-3.0, n), fill(3.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end