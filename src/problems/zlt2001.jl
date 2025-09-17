"""
    ZLT1(; T::Type{<:AbstractFloat}=Float64)

Problema ZLT1 com 10 variáveis de decisão e 5 objetivos quadráticos
estritamente convexos. Cada objetivo desloca uma variável distinta em relação
ao ponto de referência `x* = (1, 0, ..., 0)`.

Características:
- Número de variáveis: 10 (fixo)
- Número de objetivos: 5 (fixo)
- Limites: `x_i ∈ [-1000, 1000]`
- Nenhuma restrição adicional além dos limites de caixa

Fórmulas (para `k = 1,...,5`):
- `f_k(x) = sum_{i=1}^{10} x_i^2 - 2 x_k + 1`
- `∇f_k(x)_i = 2 x_i` se `i ≠ k` e `∇f_k(x)_k = 2 (x_k - 1)`

Referência:
E. Zitzler, M. Laumanns, e L. Thiele, "SPEA2: Improving the strength Pareto
evolutionary algorithm," 2001. Disponível em
https://api.semanticscholar.org/CorpusID:16584254
"""
function ZLT1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["ZLT1"]
    n = meta[:nvar]
    m = meta[:nobj]

    oneT = one(T)
    twoT = T(2)

    objectives = Vector{Function}(undef, m)
    gradients = Vector{Function}(undef, m)

    for k in 1:m
        local idx = k

        objectives[idx] = function (x)
            sum_sq = T(sum(abs2, x))
            return sum_sq - twoT * x[idx] + oneT
        end

        gradients[idx] = function (x)
            grad = twoT .* x
            grad[idx] = twoT * (x[idx] - oneT)
            return grad
        end
    end

    jacobian = function (x)
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end

    bounds = (fill(T(-1000.0), n), fill(T(1000.0), n))

    return MOProblem(
        n, m, objectives;
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity],
    )
end
