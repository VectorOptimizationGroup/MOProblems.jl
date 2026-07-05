"""
    Section 3.1 - Application 1

Referência:
- To, Thanh Binh and Korn, Ulrich, An evolution strategy for the multiobjective optimization, The Second International Conference on Genetic Algorithms, Brno, Czech Republic, 1996.

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² + x₂²
  - f₂(x) = (x₁ - 5)² + (x₂ - 5)²
- Limites: [-5, 10] para cada variável
"""
function BK1()
    meta = META["BK1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + x[2]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(5.0))^2 + (x[2] - T(5.0))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2.0) * x[1]
        grad[2] = T(2.0) * x[2]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2.0) * (x[1] - T(5.0))
        grad[2] = T(2.0) * (x[2] - T(5.0))
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-5.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end