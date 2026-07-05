"""
    Problem from:

    Das, I., & Dennis, J. E. (1998). Normal-boundary intersection: a new method for generating the Pareto surface in nonlinear multicriteria optimization problems. SIAM Journal on Optimization, 8(3), 631-657. DOI: 10.1137/S1052623496307510
"""
# ------------------------- DD1 -------------------------
"""
    DD1()

Características:
- 5 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² + x₂² + x₃² + x₄² + x₅²
  - f₂(x) = 3x₁ + 2x₂ - x₃/3 + 0.01 * (x₄ - x₅)³
- Limites: [-20, 20] para todas as variáveis
"""
function DD1()
    meta = META["DD1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        acc = zero(T)
        for xi in x
            acc += xi^2
        end
        return acc
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        d = x[4] - x[5]
        return T(3) * x[1] + T(2) * x[2] - x[3] / T(3) + T(0.01) * d^3
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in eachindex(x)
            grad[i] = T(2) * x[i]
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        d2 = (x[4] - x[5])^2
        grad[1] = T(3)
        grad[2] = T(2)
        grad[3] = -one(T) / T(3)
        grad[4] = T(0.03) * d2
        grad[5] = -T(0.03) * d2
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-20.0, n), fill(20.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end