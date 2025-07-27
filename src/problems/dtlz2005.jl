"""
    DTLZ - Problemas de Otimização Multiobjetivo Escaláveis

Este módulo contém implementações dos problemas DTLZ (Deb, Thiele, Laumanns, e Zitzler),
que são problemas de teste escaláveis para otimização multiobjetivo.

Referência:
Deb, K., Thiele, L., Laumanns, M., Zitzler, E. (2005). Scalable Test Problems for Evolutionary Multiobjective Optimization. In: Abraham, A., Jain, L., Goldberg, R. (eds) Evolutionary Multiobjective Optimization. Advanced Information and Knowledge Processing. Springer, London. DOI: 10.1007/1-84628-137-7_6

"""

# DTLZ1 - Problema linear

"""
    DTLZ1(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)

Problema DTLZ1 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: linear
- Todos os objetivos são não-convexos

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)
- `T`: tipo de ponto flutuante (default: Float64)

Fórmulas:
- f₁(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-1}
- f₂(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-2} * (1 - x_{m-1})
- f₃(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-3} * (1 - x_{m-2})
- ...
- fₘ(x) = 0.5 * (1 + g(x)) * (1 - x₁)

onde g(x) = 100 * (k + Σᵢ₌ₘⁿ [(xᵢ - 0.5)² - cos(20π(xᵢ - 0.5))])
"""
function DTLZ1(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)
    @assert k >= 1 "k deve ser pelo menos 1"
    @assert m >= 2 "m deve ser pelo menos 2"
    
    n = k + m - 1
    meta = META["DTLZ1"]
    
    # Função auxiliar g(x)
    g = x -> begin
        sum_term = T(0.0)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20.0) * π * (x[i] - T(0.5)))
        end
        return T(100.0) * (k + sum_term)
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = x -> begin
            gx = g(x)
            result = T(0.5) * (T(1.0) + gx)
            
            # Produto dos primeiros (m-i) termos
            for j in 1:(m-i)
                result *= x[j]
            end
            
            # Multiplicar por (1 - x_{m-i+1}) se i > 1
            if i > 1
                result *= (T(1.0) - x[m-i+1])
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = x -> begin
            grad = zeros(T, n)
            
            # Calcular g(x) e sua derivada
            gx = g(x)
            
            # Derivada da função auxiliar g(x) em relação a x[j] para j >= m
            dg_dx = zeros(T, n)
            for j in m:n
                dg_dx[j] = T(100.0) * (T(2.0) * (x[j] - T(0.5)) + T(20.0) * π * sin(T(20.0) * π * (x[j] - T(0.5))))
            end
            
            # Calcular o produto dos primeiros (m-i) termos
            prod_term = T(1.0)
            for j in 1:(m-i)
                prod_term *= x[j]
            end
            
            # Multiplicar por (1 - x_{m-i+1}) se i > 1
            if i > 1
                prod_term *= (T(1.0) - x[m-i+1])
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = 0.5 * (1 + g(x)) * (produto dos outros termos) * (1/x_j)
                other_prod = T(1.0)
                for k in 1:(m-i)
                    if k != j
                        other_prod *= x[k]
                    end
                end
                if i > 1
                    other_prod *= (T(1.0) - x[m-i+1])
                end
                grad[j] = T(0.5) * (T(1.0) + gx) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                grad[m-i+1] = -T(0.5) * (T(1.0) + gx) * prod_term / (T(1.0) - x[m-i+1])
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = T(0.5) * dg_dx[j] * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    # Jacobiana completa
    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end
    
    # Gerar convexidade dinamicamente baseada no número de objetivos
    convexity = fill(:non_convex, m)
    
    return MOProblem{T}(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(T, n), ones(T, n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = gradients,    # jacobiana por linha
        convexity = convexity           # convexidade dos objetivos
    )
end

# DTLZ2 - Problema não convexo

"""
    DTLZ2(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)

Problema DTLZ2 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa
- Todos os objetivos são não-convexos

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)
- `T`: tipo de ponto flutuante (default: Float64)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-2} * π/2) * sin(x_{m-1} * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-3} * π/2) * sin(x_{m-2} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁ * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ2(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)
    @assert k >= 1 "k deve ser pelo menos 1"
    @assert m >= 2 "m deve ser pelo menos 2"
    
    n = k + m - 1
    meta = META["DTLZ2"]
    
    # Função auxiliar g(x)
    g = x -> begin
        sum_term = T(0.0)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = x -> begin
            gx = g(x)
            result = T(1.0) + gx
            
            # Produto dos primeiros (m-i) termos com cos
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1] * π / T(2.0))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = x -> begin
            grad = zeros(T, n)
            gx = g(x)
            
            # Derivada da função auxiliar g(x) em relação a x[j] para j >= m
            dg_dx = zeros(T, n)
            for j in m:n
                dg_dx[j] = T(2.0) * (x[j] - T(0.5))
            end
            
            # Calcular o produto dos primeiros (m-i) termos com cos
            prod_term = T(1.0)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2.0))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * sin(x_j * π/2)) * (produto dos outros cos)
                other_prod = T(1.0)
                for k in 1:(m-i)
                    if k != j
                        other_prod *= cos(x[k] * π / T(2.0))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2.0))
                end
                grad[j] = (T(1.0) + gx) * (-π / T(2.0)) * sin(x[j] * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = T(1.0)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2.0))
                end
                grad[m-i+1] = (T(1.0) + gx) * (π / T(2.0)) * cos(x[m-i+1] * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = dg_dx[j] * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    # Jacobiana completa
    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end
    
    # Gerar convexidade dinamicamente baseada no número de objetivos
    convexity = fill(:non_convex, m)
    
    return MOProblem{T}(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(T, n), ones(T, n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = gradients,    # jacobiana por linha
        convexity = convexity           # convexidade dos objetivos
    )
end 

# DTLZ3 - Problema não convexo com função auxiliar complexa

"""
    DTLZ3(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)

Problema DTLZ3 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa
- Todos os objetivos são não-convexos
- Função auxiliar mais complexa que DTLZ2

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)
- `T`: tipo de ponto flutuante (default: Float64)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-2} * π/2) * sin(x_{m-1} * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-3} * π/2) * sin(x_{m-2} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁ * π/2)

onde g(x) = 100 * (k + Σᵢ₌ₘⁿ [(xᵢ - 0.5)² - cos(20π(xᵢ - 0.5))])
"""
function DTLZ3(; k::Int = 5, m::Int = 3, T::Type{<:AbstractFloat} = Float64)
    @assert k >= 1 "k deve ser pelo menos 1"
    @assert m >= 2 "m deve ser pelo menos 2"
    
    n = k + m - 1
    meta = META["DTLZ3"]
    
    # Função auxiliar g(x) - mais complexa que DTLZ2
    g = x -> begin
        sum_term = T(0.0)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20.0) * π * (x[i] - T(0.5)))
        end
        return T(100.0) * (k + sum_term)
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = x -> begin
            gx = g(x)
            result = T(1.0) + gx
            
            # Produto dos primeiros (m-i) termos com cos
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1] * π / T(2.0))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = x -> begin
            grad = zeros(T, n)
            gx = g(x)
            
            # Derivada da função auxiliar g(x) em relação a x[j] para j >= m
            dg_dx = zeros(T, n)
            for j in m:n
                dg_dx[j] = T(100.0) * (T(2.0) * (x[j] - T(0.5)) + T(20.0) * π * sin(T(20.0) * π * (x[j] - T(0.5))))
            end
            
            # Calcular o produto dos primeiros (m-i) termos com cos
            prod_term = T(1.0)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2.0))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * sin(x_j * π/2)) * (produto dos outros cos)
                other_prod = T(1.0)
                for k in 1:(m-i)
                    if k != j
                        other_prod *= cos(x[k] * π / T(2.0))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2.0))
                end
                grad[j] = (T(1.0) + gx) * (-π / T(2.0)) * sin(x[j] * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = T(1.0)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2.0))
                end
                grad[m-i+1] = (T(1.0) + gx) * (π / T(2.0)) * cos(x[m-i+1] * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = dg_dx[j] * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    # Jacobiana completa
    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end
    
    # Gerar convexidade dinamicamente baseada no número de objetivos
    convexity = fill(:non_convex, m)
    
    return MOProblem{T}(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(T, n), ones(T, n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = gradients,    # jacobiana por linha
        convexity = convexity           # convexidade dos objetivos
    )
end 

# DTLZ4 - Problema não convexo com parâmetro alpha

"""
    DTLZ4(; k::Int = 5, m::Int = 3, alpha::Real = 2.0, T::Type{<:AbstractFloat} = Float64)

Problema DTLZ4 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa
- Todos os objetivos são não-convexos
- Parâmetro alpha controla a distribuição das soluções

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)
- `alpha`: parâmetro de controle da distribuição (default: 2.0)
- `T`: tipo de ponto flutuante (default: Float64)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-1}^α * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-2}^α * π/2) * sin(x_{m-1}^α * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-3}^α * π/2) * sin(x_{m-2}^α * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁^α * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ4(; k::Int = 5, m::Int = 3, alpha::Real = 2.0, T::Type{<:AbstractFloat} = Float64)
    @assert k >= 1 "k deve ser pelo menos 1"
    @assert m >= 2 "m deve ser pelo menos 2"
    @assert alpha > 0 "alpha deve ser positivo"
    
    n = k + m - 1
    meta = META["DTLZ4"]
    alpha_T = T(alpha)
    
    # Função auxiliar g(x)
    g = x -> begin
        sum_term = T(0.0)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = x -> begin
            gx = g(x)
            result = T(1.0) + gx
            
            # Produto dos primeiros (m-i) termos com cos(x^alpha)
            for j in 1:(m-i)
                result *= cos(x[j]^alpha_T * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1}^alpha * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1]^alpha_T * π / T(2.0))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = x -> begin
            grad = zeros(T, n)
            gx = g(x)
            
            # Derivada da função auxiliar g(x) em relação a x[j] para j >= m
            dg_dx = zeros(T, n)
            for j in m:n
                dg_dx[j] = T(2.0) * (x[j] - T(0.5))
            end
            
            # Calcular o produto dos primeiros (m-i) termos com cos(x^alpha)
            prod_term = T(1.0)
            for j in 1:(m-i)
                prod_term *= cos(x[j]^alpha_T * π / T(2.0))
            end
            
            # Multiplicar por sin(x_{m-i+1}^alpha * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1]^alpha_T * π / T(2.0))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * α * x_j^(α-1) * sin(x_j^α * π/2)) * (produto dos outros cos)
                other_prod = T(1.0)
                for k in 1:(m-i)
                    if k != j
                        other_prod *= cos(x[k]^alpha_T * π / T(2.0))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1]^alpha_T * π / T(2.0))
                end
                grad[j] = (T(1.0) + gx) * (-π / T(2.0)) * alpha_T * x[j]^(alpha_T - T(1.0)) * sin(x[j]^alpha_T * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = T(1.0)
                for j in 1:(m-i)
                    other_prod *= cos(x[j]^alpha_T * π / T(2.0))
                end
                grad[m-i+1] = (T(1.0) + gx) * (π / T(2.0)) * alpha_T * x[m-i+1]^(alpha_T - T(1.0)) * cos(x[m-i+1]^alpha_T * π / T(2.0)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = dg_dx[j] * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    # Jacobiana completa
    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end
    
    # Gerar convexidade dinamicamente baseada no número de objetivos
    convexity = fill(:non_convex, m)
    
    return MOProblem{T}(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(T, n), ones(T, n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = gradients,    # jacobiana por linha
        convexity = convexity           # convexidade dos objetivos
    )
end 

# DTLZ5 - Problema não convexo com variáveis theta

"""
    DTLZ5(; k::Int = 5, m::Int = 5, T::Type{<:AbstractFloat} = Float64)

Problema DTLZ5 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 9)
- Número de objetivos: m (default: 5)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: degenerada (curva)
- Todos os objetivos são não-convexos
- Usa transformação de variáveis theta

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 5)
- `T`: tipo de ponto flutuante (default: Float64)

Fórmulas:
- θ₁ = x₁
- θᵢ = π/(4(1 + g(x))) * (1 + 2g(x)xᵢ) para i = 2, ..., m-1
- f₁(x) = (1 + g(x)) * cos(θ₁ * π/2) * cos(θ₂ * π/2) * ... * cos(θ_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(θ₁ * π/2) * cos(θ₂ * π/2) * ... * cos(θ_{m-2} * π/2) * sin(θ_{m-1} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(θ₁ * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ5(; k::Int = 5, m::Int = 5, T::Type{<:AbstractFloat} = Float64)
    @assert k >= 1 "k deve ser pelo menos 1"
    @assert m >= 2 "m deve ser pelo menos 2"
    
    n = k + m - 1
    meta = META["DTLZ5"]
    
    # Funções objetivo (seguindo exatamente o Fortran)
    objectives = Function[]
    
    for ind in 1:m
        f_ind = x -> begin
            # Calcular g(x) = faux
            faux = T(0.0)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            # Calcular theta
            theta = zeros(T, m-1)
            theta[1] = x[1]
            a = π / (T(4.0) * (T(1.0) + faux))
            for i in 2:(m-1)
                theta[i] = a * (T(1.0) + T(2.0) * faux * x[i])
            end
            
            # Calcular função objetivo f
            f = T(1.0) + faux
            for i in 1:(m-ind)
                f *= cos(theta[i] * π / T(2.0))
            end
            
            if ind > 1
                f *= sin(theta[m-ind+1] * π / T(2.0))
            end
            
            return f
        end
        push!(objectives, f_ind)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for ind in 1:m
        df_ind_dx = x -> begin
            # Inicializar gradiente como zeros
            g = zeros(T, n)
            
            # Calcular g(x) = faux
            faux = T(0.0)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            # Calcular theta e thetader
            theta = zeros(T, m-1)
            thetader = zeros(T, m-1)
            
            theta[1] = x[1]
            thetader[1] = T(1.0)
            a = π / (T(4.0) * (T(1.0) + faux))
            b = a * T(2.0) * faux
            for i in 2:(m-1)
                theta[i] = a * (T(1.0) + T(2.0) * faux * x[i])
                thetader[i] = b
            end
            
            faux = T(1.0) + faux  # Agora faux = 1 + g(x)
            
            # Calcular derivadas para i = 1 até m-ind
            for i in 1:(m-ind)
                g[i] = faux
            end
            
            for i in 1:(m-ind)
                for j in 1:(m-ind)
                    if j == i
                        g[i] = -g[i] * π / T(2.0) * thetader[i] * sin(theta[i] * π / T(2.0))
                    else
                        g[i] = g[i] * cos(theta[j] * π / T(2.0))
                    end
                end
                if ind > 1
                    g[i] = g[i] * sin(theta[m-ind+1] * π / T(2.0))
                end
            end
            
            # Derivada para x_{m-ind+1} se ind > 1
            if ind > 1
                g[m-ind+1] = faux * π / T(2.0) * thetader[m-ind+1] * cos(theta[m-ind+1] * π / T(2.0))
                for j in 1:(m-ind)
                    g[m-ind+1] = g[m-ind+1] * cos(theta[j] * π / T(2.0))
                end
            end
            
            # Calcular faux para derivadas em relação a x[i] para i >= m
            # ------------------------------------------------------------------
            # NOVO: Derivadas corretas para x[i] com i ≥ m, incluindo influência
            #      indireta através das variáveis θ (que dependem de g(x)).
            # ------------------------------------------------------------------

            # Armazenar (1 + g(x)) para fácil leitura
            one_plus_g = faux  # faux já contém 1 + g(x)

            for i in m:n  # Para cada variável de decisão na parte de g(x)
                dg_dx = T(2.0) * (x[i] - T(0.5))               # ∂g/∂xᵢ

                # Produto de cossenos presentes em f_ind
                cos_prod = T(1.0)
                for j in 1:(m-ind)
                    cos_prod *= cos(theta[j] * π / T(2.0))
                end

                # Fator seno quando ind > 1
                sin_factor = ind > 1 ? sin(theta[m-ind+1] * π / T(2.0)) : T(1.0)

                # Contribuição direta de (1+g)
                deriv = dg_dx * cos_prod * sin_factor

                # ----------------- Termos adicionais provenientes de θ -----------------
                sum_term = T(0.0)
                for j in 2:(m-1)
                    if j <= m - ind  # θ_j aparece apenas no produto de cossenos
                        dtheta = dg_dx * a * ( - (T(1.0) + T(2.0) * (one_plus_g - T(1.0)) * x[j]) / one_plus_g + T(2.0) * x[j] )
                        sum_term += (-π / T(2.0)) * tan(theta[j] * π / T(2.0)) * dtheta
                    end
                end
                dcos_prod = cos_prod * sum_term

                # Derivada do fator seno (se existir)
                dsin_factor = T(0.0)
                if ind > 1
                    k_idx = m - ind + 1
                    if k_idx >= 2  # θ₁ = x₁ não depende de g(x)
                        dtheta_k = dg_dx * a * ( - (T(1.0) + T(2.0) * (one_plus_g - T(1.0)) * x[k_idx]) / one_plus_g + T(2.0) * x[k_idx] )
                        dsin_factor = (π / T(2.0)) * cos(theta[k_idx] * π / T(2.0)) * dtheta_k
                    end
                end

                # Agregar contribuições indiretas
                deriv += one_plus_g * (dcos_prod * sin_factor + cos_prod * dsin_factor)

                # Atualizar o gradiente
                g[i] = deriv
            end
            
            return g
        end
        push!(gradients, df_ind_dx)
    end
    
    # Jacobiana completa
    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end
    
    # Gerar convexidade dinamicamente baseada no número de objetivos
    convexity = fill(:non_convex, m)
    
    return MOProblem{T}(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(T, n), ones(T, n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = gradients,    # jacobiana por linha
        convexity = convexity           # convexidade dos objetivos
    )
end