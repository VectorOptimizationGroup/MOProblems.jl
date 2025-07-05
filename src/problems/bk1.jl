"""
    BK1()

Problema BK1: Teste de "A Review of Multiobjective Test Problems and a Scalable Test Problem Toolkit"

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² + x₂²
  - f₂(x) = (x₁ - 5)² + (x₂ - 5)²
- Limites: [-5, 10] para cada variável
- Convexidade: [estritamente convexa, estritamente convexa]
"""
function BK1()
    meta = META["BK1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Funções objetivo
    f1 = x -> x[1]^2 + x[2]^2
    f2 = x -> (x[1] - 5.0)^2 + (x[2] - 5.0)^2

    # Gradientes
    df1_dx = x -> begin
        grad = zeros(n)
        grad[1] = 2.0 * x[1]
        grad[2] = 2.0 * x[2]
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(n)
        grad[1] = 2.0 * (x[1] - 5.0)
        grad[2] = 2.0 * (x[2] - 5.0)
        return grad
    end

    # Jacobiana completa (2 × 2)
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
        bounds = (fill(-5.0, n), fill(10.0, n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end 