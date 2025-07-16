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
- Convexidade: [:strictly_convex, :non_convex]
"""
function DD1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["DD1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Funções objetivo
    f1 = x -> sum(x.^2)
    f2 = x -> T(3) * x[1] + T(2) * x[2] - x[3] / T(3) + T(0.01) * (x[4] - x[5])^3

    # Gradientes
    df1_dx = x -> T(2) .* x

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(3)
        grad[2] = T(2)
        grad[3] = -one(T) / T(3)
        grad[4] = T(0.03) * (x[4] - x[5])^2
        grad[5] = -T(0.03) * (x[4] - x[5])^2
        return grad
    end

    # Jacobiana completa (2 × 5)
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    # Criar o problema
    prob = MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-20.0), n), fill(T(20.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end 