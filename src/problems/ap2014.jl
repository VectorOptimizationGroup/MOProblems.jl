"""
    Examples 1, 2, 3 and 4 from:

    Ansary, Md. A. T., & Panda, G. (2014). A modified Quasi-Newton method for vector optimization problem. Optimization, 64(11), 2289–2306. DOI: 10.1080/02331934.2014.947500
"""
# ------------------------- AP1 -------------------------
"""
    AP1()

Características
- 2 variáveis
- 3 funções objetivo
- Objetivos:
  - f₁(x) = 0.25 * ((x₁ - 1)^4 + 2(x₂ - 2)^4)
  - f₂(x) = exp((x₁ + x₂)/2) + x₁² + x₂²
  - f₃(x) = (1/6) * (exp(-x₁) + 2exp(-x₂))
- Limites: [-10, 10] para todas as variáveis
- Convexidade: [não convexo, estritamente convexo, estritamente convexo]
"""
function AP1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["AP1"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> T(0.25) * ((x[1] - T(1.0))^4 + T(2.0) * (x[2] - T(2.0))^4)
    f2 = x -> exp((x[1] + x[2]) / T(2.0)) + x[1]^2 + x[2]^2
    f3 = x -> (T(1.0) / T(6.0)) * (exp(-x[1]) + T(2.0) * exp(-x[2]))

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = (x[1] - T(1.0))^3
        grad[2] = T(2.0) * (x[2] - T(2.0))^3
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        exp_term = exp((x[1] + x[2]) / T(2.0))
        grad[1] = T(0.5) * exp_term + T(2.0) * x[1]
        grad[2] = T(0.5) * exp_term + T(2.0) * x[2]
        return grad
    end

    df3_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = -(T(1.0) / T(6.0)) * exp(-x[1])
        grad[2] = -(T(1.0) / T(3.0)) * exp(-x[2])
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)'; df3_dx(x)']

    prob = MOProblem(
        n,
        m,
        [f1, f2, f3];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-10.0), n), fill(T(10.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx, df3_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end

# ------------------------- AP2 -------------------------
"""
    AP2()

Características
- 1 variável
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² - 4
  - f₂(x) = (x₁ - 1)²
- Limites: [-100, 100]
- Convexidade: [estritamente convexa, estritamente convexa]
"""
function AP2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["AP2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]^2 - T(4.0)
    f2 = x -> (x[1] - T(1.0))^2

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * x[1]
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * (x[1] - T(1.0))
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    prob = MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-100.0), n), fill(T(100.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end

# ------------------------- AP3 -------------------------
"""
    AP3()

"""
function AP3(; T::Type{<:AbstractFloat}=Float64)
    meta = META["AP3"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> T(0.25) * ((x[1] - T(1.0))^4 + T(2.0) * (x[2] - T(2.0))^4)
    f2 = x -> (x[2] - x[1]^2)^2 + (T(1.0) - x[1])^2

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = (x[1] - T(1.0))^3
        grad[2] = T(2.0) * (x[2] - T(2.0))^3
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = -T(4.0) * x[1] * (x[2] - x[1]^2) - T(2.0) * (T(1.0) - x[1])
        grad[2] = T(2.0) * (x[2] - x[1]^2)
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    prob = MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-100.0), n), fill(T(100.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end

# ------------------------- AP4 -------------------------
"""
    AP4()

"""
function AP4(; T::Type{<:AbstractFloat}=Float64)
    meta = META["AP4"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> (T(1.0) / T(9.0)) * ((x[1] - T(1.0))^4 + T(2.0) * (x[2] - T(2.0))^4 + T(3.0) * (x[3] - T(3.0))^4)
    f2 = x -> exp((x[1] + x[2] + x[3]) / T(3.0)) + x[1]^2 + x[2]^2 + x[3]^2
    f3 = x -> (T(1.0) / T(12.0)) * (T(3.0) * exp(-x[1]) + T(4.0) * exp(-x[2]) + T(3.0) * exp(-x[3]))

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = (T(4.0) / T(9.0)) * (x[1] - T(1.0))^3
        grad[2] = (T(8.0) / T(9.0)) * (x[2] - T(2.0))^3
        grad[3] = (T(12.0) / T(9.0)) * (x[3] - T(3.0))^3
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        exp_term = exp((x[1] + x[2] + x[3]) / T(3.0))
        grad[1] = (T(1.0) / T(3.0)) * exp_term + T(2.0) * x[1]
        grad[2] = (T(1.0) / T(3.0)) * exp_term + T(2.0) * x[2]
        grad[3] = (T(1.0) / T(3.0)) * exp_term + T(2.0) * x[3]
        return grad
    end

    df3_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = -(T(1.0) / T(4.0)) * exp(-x[1])
        grad[2] = -(T(1.0) / T(3.0)) * exp(-x[2])
        grad[3] = -(T(1.0) / T(4.0)) * exp(-x[3])
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)'; df3_dx(x)']

    prob = MOProblem(
        n,
        m,
        [f1, f2, f3];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-10.0), n), fill(T(10.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx, df3_dx],
        convexity = meta[:convexity]
    )

    register_problem(prob)
    return prob
end 