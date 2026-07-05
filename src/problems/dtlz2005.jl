"""
    DTLZ - Problemas de Otimização Multiobjetivo Escaláveis

Este módulo contém implementações dos problemas DTLZ (Deb, Thiele, Laumanns, e Zitzler),
que são problemas de teste escaláveis para otimização multiobjetivo.

Referência:
Deb, K., Thiele, L., Laumanns, M., Zitzler, E. (2005). Scalable Test Problems for Evolutionary Multiobjective Optimization. In: Abraham, A., Jain, L., Goldberg, R. (eds) Evolutionary Multiobjective Optimization. Advanced Information and Knowledge Processing. Springer, London. DOI: 10.1007/1-84628-137-7_6

"""

# DTLZ1 - Problema linear

"""
    DTLZ1(; k::Int = 5, m::Int = 3)

Problema DTLZ1 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: linear

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)

Fórmulas:
- f₁(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-1}
- f₂(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-2} * (1 - x_{m-1})
- f₃(x) = 0.5 * (1 + g(x)) * x₁ * x₂ * ... * x_{m-3} * (1 - x_{m-2})
- ...
- fₘ(x) = 0.5 * (1 + g(x)) * (1 - x₁)

onde g(x) = 100 * (k + Σᵢ₌ₘⁿ [(xᵢ - 0.5)² - cos(20π(xᵢ - 0.5))])
"""
function DTLZ1(; k::Int = 5, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ1"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20) * π * (x[i] - T(0.5)))
        end
        return T(100) * (T(k) + sum_term)
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = T(0.5) * (one(T) + gx)
            
            # Produto dos primeiros (m-i) termos
            for j in 1:(m-i)
                result *= x[j]
            end
            
            # Multiplicar por (1 - x_{m-i+1}) se i > 1
            if i > 1
                result *= (one(T) - x[m-i+1])
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            
            # Calcular g(x) e sua derivada
            gx = g(x)
            
            # Calcular o produto dos primeiros (m-i) termos
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= x[j]
            end
            
            # Multiplicar por (1 - x_{m-i+1}) se i > 1
            if i > 1
                prod_term *= (one(T) - x[m-i+1])
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = 0.5 * (1 + g(x)) * (produto dos outros termos) * (1/x_j)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= x[l]
                    end
                end
                if i > 1
                    other_prod *= (one(T) - x[m-i+1])
                end
                grad[j] = T(0.5) * (one(T) + gx) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                grad[m-i+1] = -T(0.5) * (one(T) + gx) * prod_term / (one(T) - x[m-i+1])
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                dg_dx = T(100) * (T(2) * (x[j] - T(0.5)) + T(20) * π * sin(T(20) * π * (x[j] - T(0.5))))
                grad[j] = T(0.5) * dg_dx * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta.name,             # nome
        bounds = (zeros(n), ones(n)),   # limites
        jacobian = gradients,    # jacobiana por linha
    )
end

# DTLZ2 - Problema não convexo

"""
    DTLZ2(; k::Int = 5, m::Int = 3)

Problema DTLZ2 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-2} * π/2) * sin(x_{m-1} * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-3} * π/2) * sin(x_{m-2} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁ * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ2(; k::Int = 5, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ2"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = one(T) + gx
            
            # Produto dos primeiros (m-i) termos com cos
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1] * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            gx = g(x)
            
            # Calcular o produto dos primeiros (m-i) termos com cos
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * sin(x_j * π/2)) * (produto dos outros cos)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l] * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * sin(x[j] * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * cos(x[m-i+1] * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = T(2) * (x[j] - T(0.5)) * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta.name,             # nome
        bounds = (zeros(n), ones(n)),   # limites
        jacobian = gradients,    # jacobiana por linha
    )
end 

# DTLZ3 - Problema não convexo com função auxiliar complexa

"""
    DTLZ3(; k::Int = 5, m::Int = 3)

Problema DTLZ3 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa
- Função auxiliar mais complexa que DTLZ2

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-2} * π/2) * sin(x_{m-1} * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁ * π/2) * cos(x₂ * π/2) * ... * cos(x_{m-3} * π/2) * sin(x_{m-2} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁ * π/2)

onde g(x) = 100 * (k + Σᵢ₌ₘⁿ [(xᵢ - 0.5)² - cos(20π(xᵢ - 0.5))])
"""
function DTLZ3(; k::Int = 5, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ3"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20) * π * (x[i] - T(0.5)))
        end
        return T(100) * (T(k) + sum_term)
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = one(T) + gx
            
            # Produto dos primeiros (m-i) termos com cos
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1] * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            gx = g(x)
            
            # Calcular o produto dos primeiros (m-i) termos com cos
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1} * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * sin(x_j * π/2)) * (produto dos outros cos)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l] * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * sin(x[j] * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * cos(x[m-i+1] * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                dg_dx = T(100) * (T(2) * (x[j] - T(0.5)) + T(20) * π * sin(T(20) * π * (x[j] - T(0.5))))
                grad[j] = dg_dx * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta.name,             # nome
        bounds = (zeros(n), ones(n)),   # limites
        jacobian = gradients,    # jacobiana por linha
    )
end 

# DTLZ4 - Problema não convexo com parâmetro alpha

"""
    DTLZ4(; k::Int = 5, m::Int = 3, alpha::Real = 2.0)

Problema DTLZ4 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 7)
- Número de objetivos: m (default: 3)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: não convexa
- Parâmetro alpha controla a distribuição das soluções

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 3)
- `alpha`: parâmetro de controle da distribuição (default: 2.0)

Fórmulas:
- f₁(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-1}^α * π/2)
- f₂(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-2}^α * π/2) * sin(x_{m-1}^α * π/2)
- f₃(x) = (1 + g(x)) * cos(x₁^α * π/2) * cos(x₂^α * π/2) * ... * cos(x_{m-3}^α * π/2) * sin(x_{m-2}^α * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(x₁^α * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ4(; k::Int = 5, m::Int = 3, alpha::Real = 2.0)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    @assert alpha > 0 "alpha deve ser positivo"
    
    n = k + m - 1
    meta = META["DTLZ4"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    # Funções objetivo
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            alpha_T = T(alpha)
            gx = g(x)
            result = one(T) + gx
            
            # Produto dos primeiros (m-i) termos com cos(x^alpha)
            for j in 1:(m-i)
                result *= cos(x[j]^alpha_T * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1}^alpha * π/2) se i > 1
            if i > 1
                result *= sin(x[m-i+1]^alpha_T * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            alpha_T = T(alpha)
            gx = g(x)
            
            # Calcular o produto dos primeiros (m-i) termos com cos(x^alpha)
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j]^alpha_T * π / T(2))
            end
            
            # Multiplicar por sin(x_{m-i+1}^alpha * π/2) se i > 1
            if i > 1
                prod_term *= sin(x[m-i+1]^alpha_T * π / T(2))
            end
            
            # Derivada em relação a x[j] para j < m
            for j in 1:(m-i)
                # ∂f_i/∂x_j = (1 + g(x)) * (-π/2 * α * x_j^(α-1) * sin(x_j^α * π/2)) * (produto dos outros cos)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l]^alpha_T * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1]^alpha_T * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * alpha_T * x[j]^(alpha_T - one(T)) * sin(x[j]^alpha_T * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x_{m-i+1} se i > 1
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j]^alpha_T * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * alpha_T * x[m-i+1]^(alpha_T - one(T)) * cos(x[m-i+1]^alpha_T * π / T(2)) * other_prod
            end
            
            # Derivada em relação a x[j] para j >= m
            for j in m:n
                grad[j] = T(2) * (x[j] - T(0.5)) * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta.name,             # nome
        bounds = (zeros(n), ones(n)),   # limites
        jacobian = gradients,    # jacobiana por linha
    )
end 

# DTLZ5 - Problema não convexo com variáveis theta

"""
    DTLZ5(; k::Int = 5, m::Int = 5)

Problema DTLZ5 com `k` variáveis de decisão e `m` objetivos.

Características:
- Número de variáveis: k + m - 1 (default: 9)
- Número de objetivos: m (default: 5)
- Domínio: [0, 1]^(k+m-1)
- Fronteira de Pareto: degenerada (curva)
- Usa transformação de variáveis theta

Parâmetros:
- `k`: número de variáveis de decisão (default: 5)
- `m`: número de objetivos (default: 5)

Fórmulas:
- θ₁ = x₁
- θᵢ = π/(4(1 + g(x))) * (1 + 2g(x)xᵢ) para i = 2, ..., m-1
- f₁(x) = (1 + g(x)) * cos(θ₁ * π/2) * cos(θ₂ * π/2) * ... * cos(θ_{m-1} * π/2)
- f₂(x) = (1 + g(x)) * cos(θ₁ * π/2) * cos(θ₂ * π/2) * ... * cos(θ_{m-2} * π/2) * sin(θ_{m-1} * π/2)
- ...
- fₘ(x) = (1 + g(x)) * sin(θ₁ * π/2)

onde g(x) = Σᵢ₌ₘⁿ (xᵢ - 0.5)²
"""
function DTLZ5(; k::Int = 5, m::Int = 5)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ5"]
    
    # Funções objetivo (seguindo exatamente o Fortran)
    objectives = Function[]
    
    for ind in 1:m
        f_ind = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            # Calcular g(x) = faux
            faux = zero(T)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            a = π / (T(4) * (one(T) + faux))
            
            # Calcular função objetivo f
            f = one(T) + faux
            for i in 1:(m-ind)
                theta_i = i == 1 ? x[1] : a * (one(T) + T(2) * faux * x[i])
                f *= cos(theta_i * π / T(2))
            end
            
            if ind > 1
                theta_i = m - ind + 1 == 1 ? x[1] : a * (one(T) + T(2) * faux * x[m-ind+1])
                f *= sin(theta_i * π / T(2))
            end
            
            return f
        end
        push!(objectives, f_ind)
    end
    
    # Derivadas das funções objetivo (baseadas no código Fortran)
    gradients = Function[]
    
    for ind in 1:m
        df_ind_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            
            # Calcular g(x) = faux
            faux = zero(T)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            a = π / (T(4) * (one(T) + faux))
            b = a * T(2) * faux
            
            faux = one(T) + faux  # Agora faux = 1 + g(x)
            
            # Calcular derivadas para i = 1 até m-ind
            for i in 1:(m-ind)
                grad[i] = faux
            end
            
            for i in 1:(m-ind)
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[j])
                    if j == i
                        thetader_i = i == 1 ? one(T) : b
                        grad[i] = -grad[i] * π / T(2) * thetader_i * sin(theta_j * π / T(2))
                    else
                        grad[i] *= cos(theta_j * π / T(2))
                    end
                end
                if ind > 1
                    theta_i = m - ind + 1 == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[m-ind+1])
                    grad[i] *= sin(theta_i * π / T(2))
                end
            end
            
            # Derivada para x_{m-ind+1} se ind > 1
            if ind > 1
                idx = m - ind + 1
                theta_idx = idx == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[idx])
                thetader_idx = idx == 1 ? one(T) : b
                grad[idx] = faux * π / T(2) * thetader_idx * cos(theta_idx * π / T(2))
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[j])
                    grad[idx] *= cos(theta_j * π / T(2))
                end
            end
            
            one_plus_g = faux  # faux já contém 1 + g(x)

            for i in m:n  # Para cada variável de decisão na parte de g(x)
                dg_dx = T(2) * (x[i] - T(0.5))               # ∂g/∂xᵢ

                # Produto de cossenos presentes em f_ind
                cos_prod = one(T)
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (one_plus_g - one(T)) * x[j])
                    cos_prod *= cos(theta_j * π / T(2))
                end

                # Fator seno quando ind > 1
                sin_factor = one(T)
                if ind > 1
                    idx = m - ind + 1
                    theta_idx = idx == 1 ? x[1] : a * (one(T) + T(2) * (one_plus_g - one(T)) * x[idx])
                    sin_factor = sin(theta_idx * π / T(2))
                end

                # Contribuição direta de (1+g)
                deriv = dg_dx * cos_prod * sin_factor

                # ----------------- Termos adicionais provenientes de θ -----------------
                sum_term = zero(T)
                for j in 2:(m-1)
                    if j <= m - ind  # θ_j aparece apenas no produto de cossenos
                        theta_j = a * (one(T) + T(2) * (one_plus_g - one(T)) * x[j])
                        dtheta = dg_dx * a * ( - (one(T) + T(2) * (one_plus_g - one(T)) * x[j]) / one_plus_g + T(2) * x[j] )
                        sum_term += (-π / T(2)) * tan(theta_j * π / T(2)) * dtheta
                    end
                end
                dcos_prod = cos_prod * sum_term

                # Derivada do fator seno (se existir)
                dsin_factor = zero(T)
                if ind > 1
                    k_idx = m - ind + 1
                    if k_idx >= 2  # θ₁ = x₁ não depende de g(x)
                        theta_k = a * (one(T) + T(2) * (one_plus_g - one(T)) * x[k_idx])
                        dtheta_k = dg_dx * a * ( - (one(T) + T(2) * (one_plus_g - one(T)) * x[k_idx]) / one_plus_g + T(2) * x[k_idx] )
                        dsin_factor = (π / T(2)) * cos(theta_k * π / T(2)) * dtheta_k
                    end
                end

                # Agregar contribuições indiretas
                deriv += one_plus_g * (dcos_prod * sin_factor + cos_prod * dsin_factor)

                # Atualizar o gradiente
                grad[i] = deriv
            end
            
            return grad
        end
        push!(gradients, df_ind_dx)
    end
    
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        objectives;                     # f
        name = meta.name,             # nome
        bounds = (zeros(n), ones(n)),   # limites
        jacobian = gradients,    # jacobiana por linha
    )
end