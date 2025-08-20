"""    
    Lovison, Alberto. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis.
    SIAM Journal on Optimization, 21(2), 463-490. DOI: 10.1137/100784746
"""

# ------------------------- Lov1 -------------------------
"""    
    Lov1(; T::Type{<:AbstractFloat}=Float64)

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = -(-1.05 * x₁² - 0.98 * x₂²)
  - f₂(x) = -(-0.99 * (x₁ - 3)² - 1.03 * (x₂ - 2.5)²)
- Limites: [-10, 10] para todas as variáveis
- Convexidade: [estritamente convexa, estritamente convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Definição das funções objetivo
    f1 = x -> -(-T(1.05) * x[1]^2 - T(0.98) * x[2]^2)
    f2 = x -> -(-T(0.99) * (x[1] - T(3.0))^2 - T(1.03) * (x[2] - T(2.5))^2)

    # Gradientes das funções objetivo
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.1) * x[1]  # 2 * 1.05 * x₁
        grad[2] = T(1.96) * x[2]  # 2 * 0.98 * x₂
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(1.98) * (x[1] - T(3.0))  # 2 * 0.99 * (x₁ - 3)
        grad[2] = T(2.06) * (x[2] - T(2.5))  # 2 * 1.03 * (x₂ - 2.5)
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    bounds = (fill(T(-10.0), n), fill(T(10.0), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- Lov3 -------------------------
"""
    Lov3(; T::Type{<:AbstractFloat}=Float64)

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² + x₂²
  - f₂(x) = (x₁ - 6)² - (x₂ + 0.3)²
- Limites: [-1, 1] para todas as variáveis
- Convexidade: [estritamente convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov3(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov3"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Definição das funções objetivo baseadas na implementação Fortran90
    f1 = x -> x[1]^2 + x[2]^2
    f2 = x -> (x[1] - T(6.0))^2 - (x[2] + T(0.3))^2

    # Gradientes das funções objetivo baseados na implementação Fortran90
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * x[1]
        grad[2] = T(2.0) * x[2]
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * (x[1] - T(6.0))
        grad[2] = -T(2.0) * (x[2] + T(0.3))
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    bounds = (fill(T(-1.0), n), fill(T(1.0), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- Lov4 -------------------------
"""
    Lov4(; T::Type{<:AbstractFloat}=Float64)

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = -(-x₁² - x₂² - 4(exp(-(x₁+2)² - x₂²) + exp(-(x₁-2)² - x₂²)))
  - f₂(x) = -(-(x₁ - 6)² - (x₂ + 0.5)²)
- Limites: [-20, 20] para todas as variáveis
- Convexidade: [não convexa, estritamente convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov4(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov4"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Definição das funções objetivo
    f1 = x -> begin
        exp1 = exp(-(x[1] + T(2.0))^2 - x[2]^2)
        exp2 = exp(-(x[1] - T(2.0))^2 - x[2]^2)
        return -(-x[1]^2 - x[2]^2 - T(4.0) * (exp1 + exp2))
    end
    
    f2 = x -> -(-(x[1] - T(6.0))^2 - (x[2] + T(0.5))^2)

    # Gradientes das funções objetivo
    df1_dx = x -> begin
        grad = zeros(T, n)
        exp1 = exp(-(x[1] + T(2.0))^2 - x[2]^2)
        exp2 = exp(-(x[1] - T(2.0))^2 - x[2]^2)
        
        grad[1] = T(2.0) * x[1] - T(8.0) * ((x[1] + T(2.0)) * exp1 + (x[1] - T(2.0)) * exp2)
        grad[2] = T(2.0) * x[2] - T(8.0) * (x[2] * exp1 + x[2] * exp2)
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * (x[1] - T(6.0))
        grad[2] = T(2.0) * (x[2] + T(0.5))
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    bounds = (fill(T(-20.0), n), fill(T(20.0), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- Lov5 -------------------------
"""
    Lov5(; T::Type{<:AbstractFloat}=Float64)

Características
- 3 variáveis
- 2 funções objetivo
- Objetivos complexos com matrizes e exponenciais
- Limites: [-2, 2] para todas as variáveis
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov5(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov5"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Matriz MM
    MM = T[-1.0 -0.03 0.011; -0.03 -1.0 0.07; 0.011 0.07 -1.01]

    # Definição das funções objetivo
    f1 = x -> begin
        p1 = [x[1], x[2] - T(0.15), x[3]]
        a1 = T(0.35)
        A1 = sqrt(T(2.0) * π / a1) * exp(dot(p1, MM * p1) / a1^2)
        
        p2 = [x[1], x[2] + T(1.1), T(0.5) * x[3]]
        a2 = T(3.0)
        A2 = sqrt(T(2.0) * π / a2) * exp(dot(p2, MM * p2) / a2^2)
        
        faux = A1 + A2
        return -(sqrt(T(2.0)) / T(2.0) * (x[1] + faux))
    end
    
    f2 = x -> begin
        p1 = [x[1], x[2] - T(0.15), x[3]]
        a1 = T(0.35)
        A1 = sqrt(T(2.0) * π / a1) * exp(dot(p1, MM * p1) / a1^2)
        
        p2 = [x[1], x[2] + T(1.1), T(0.5) * x[3]]
        a2 = T(3.0)
        A2 = sqrt(T(2.0) * π / a2) * exp(dot(p2, MM * p2) / a2^2)
        
        faux = A1 + A2
        return -(sqrt(T(2.0)) / T(2.0) * (-x[1] + faux))
    end

    # Gradientes das funções objetivo (implementação simplificada)
    df1_dx = x -> begin
        grad = zeros(T, n)
        # Implementação complexa dos gradientes baseada no código Fortran
        p1 = [x[1], x[2] - T(0.15), x[3]]
        a1 = T(0.35)
        A1 = sqrt(T(2.0) * π / a1) * exp(dot(p1, MM * p1) / a1^2)
        
        p2 = [x[1], x[2] + T(1.1), T(0.5) * x[3]]
        a2 = T(3.0)
        A2 = sqrt(T(2.0) * π / a2) * exp(dot(p2, MM * p2) / a2^2)
        
        # Gradientes aproximados (baseados no código Fortran)
        grad[1] = -(sqrt(T(2.0))/T(2.0) + sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,1] * x[1] + T(2.0) * MM[1,3] * x[3] + T(2.0) * MM[1,2] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (T(2.0) * MM[1,1] * x[1] + MM[1,3] * x[3] + T(2.0) * MM[1,2] * (x[2] + T(1.1))) / T(3.0)^2)
        
        grad[2] = -(sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,2] * x[1] + T(2.0) * MM[2,3] * x[3] + T(2.0) * MM[2,2] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (T(2.0) * MM[1,2] * x[1] + MM[2,3] * x[3] + T(2.0) * MM[2,2] * (x[2] + T(1.1))) / T(3.0)^2)
        
        grad[3] = -(sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,3] * x[1] + T(2.0) * MM[3,3] * x[3] + T(2.0) * MM[2,3] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (MM[1,3] * x[1] + MM[3,3] * x[3] / T(2.0) + MM[2,3] * (x[2] + T(1.1))) / T(3.0)^2)
        
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        # Similar ao df1_dx mas com sinal diferente para x[1]
        p1 = [x[1], x[2] - T(0.15), x[3]]
        a1 = T(0.35)
        A1 = sqrt(T(2.0) * π / a1) * exp(dot(p1, MM * p1) / a1^2)
        
        p2 = [x[1], x[2] + T(1.1), T(0.5) * x[3]]
        a2 = T(3.0)
        A2 = sqrt(T(2.0) * π / a2) * exp(dot(p2, MM * p2) / a2^2)
        
        grad[1] = -(-sqrt(T(2.0))/T(2.0) + sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,1] * x[1] + T(2.0) * MM[1,3] * x[3] + T(2.0) * MM[1,2] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (T(2.0) * MM[1,1] * x[1] + MM[1,3] * x[3] + T(2.0) * MM[1,2] * (x[2] + T(1.1))) / T(3.0)^2)
        
        grad[2] = -(sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,2] * x[1] + T(2.0) * MM[2,3] * x[3] + T(2.0) * MM[2,2] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (T(2.0) * MM[1,2] * x[1] + MM[2,3] * x[3] + T(2.0) * MM[2,2] * (x[2] + T(1.1))) / T(3.0)^2)
        
        grad[3] = -(sqrt(T(2.0))/T(2.0) * A1 * 
                   (T(2.0) * MM[1,3] * x[1] + T(2.0) * MM[3,3] * x[3] + T(2.0) * MM[2,3] * (x[2] - T(0.15))) / T(0.35)^2 +
                   sqrt(T(2.0))/T(2.0) * A2 * (MM[1,3] * x[1] + MM[3,3] * x[3] / T(2.0) + MM[2,3] * (x[2] + T(1.1))) / T(3.0)^2)
        
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    bounds = (fill(T(-2.0), n), fill(T(2.0), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- Lov6 -------------------------
"""
    Lov6(; T::Type{<:AbstractFloat}=Float64)

Características
- 6 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁
  - f₂(x) = 1 - √x₁ - x₁sin(10πx₁) + x₂² + x₃² + x₄² + x₅² + x₆²
- Limites: x₁ ∈ [0.1, 0.425], x₂₋₆ ∈ [-0.16, 0.16]
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov6(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov6"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Definição das funções objetivo
    f1 = x -> x[1]
    
    f2 = x -> begin
        T(1.0) - sqrt(x[1]) - x[1] * sin(T(10.0) * π * x[1]) + 
        x[2]^2 + x[3]^2 + x[4]^2 + x[5]^2 + x[6]^2
    end

    # Gradientes das funções objetivo
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(1.0)
        # grad[2:6] = 0.0 (já inicializados como zero)
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = -T(0.5) / sqrt(x[1]) - sin(T(10.0) * π * x[1]) - T(10.0) * π * x[1] * cos(T(10.0) * π * x[1])
        for i in 2:6
            grad[i] = T(2.0) * x[i]
        end
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    lower_bounds = zeros(T, n)
    upper_bounds = zeros(T, n)
    
    lower_bounds[1] = T(0.1)
    upper_bounds[1] = T(0.425)
    
    for i in 2:6
        lower_bounds[i] = T(-0.16)
        upper_bounds[i] = T(0.16)
    end
    
    bounds = (lower_bounds, upper_bounds)

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- Lov2 -------------------------
"""    
    Lov2(; T::Type{<:AbstractFloat}=Float64)

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₂
  - f₂(x) = -((x₂ - x₁³) / (x₁ + 1))
- Limites: [-0.75, 0.75] para todas as variáveis
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Lov2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Definição das funções objetivo
    f1 = x -> x[2]
    f2 = x -> -((x[2] - x[1]^3) / (x[1] + T(1.0)))

    # Gradientes das funções objetivo
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(0.0)
        grad[2] = T(1.0)
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        # Baseado na implementação Fortran90:
        # g(1) = ( - 3.0d0 * x(1) ** 2 * ( x(1) + 1.0d0 ) - ( x(2) - x(1) ** 3 ) )
        # g(1) = - g(1) / ( x(1) + 1.0d0 ) ** 2
        # g(2) = - 1.0d0 / ( x(1) + 1.0d0 )
        
        grad[1] = -((-T(3.0) * x[1]^2 * (x[1] + T(1.0)) - (x[2] - x[1]^3)) / (x[1] + T(1.0))^2)
        grad[2] = -T(1.0) / (x[1] + T(1.0))
        return grad
    end

    # Matriz jacobiana completa (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Limites das variáveis
    bounds = (fill(T(-0.75), n), fill(T(0.75), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end