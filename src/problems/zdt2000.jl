"""
    ZDT - Problemas de Otimização Multiobjetivo Benchmark

Este módulo contém implementações dos problemas ZDT (Zitzler, Deb, e Thiele) 1-6,
que são problemas de teste comuns para otimização multiobjetivo.

Referência:
E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. DOI: 10.1162/106365600568202
"""

# ZDT1 - convexa

"""
    ZDT1(n::Int = 30)

Problema ZDT1 com `n` variáveis (default: 30).

Características:
- Número de variáveis: 30 (default, mas pode ser modificado)
- Número de objetivos: 2
- Domínio: [0, 1]^n
- Fronteira de Pareto: f₁ ∈ [0, 1], f₂ = 1 - √f₁
- Fronteira de Pareto convexa e contínua
- Objetivos: f₁ é convexo, f₂ é não-convexo

Fórmulas:
- f₁(x) = x₁
- f₂(x) = g(x) * [1 - √(f₁(x)/g(x))]
- g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
"""
function ZDT1(n::Int = 30)
    @assert n >= 2 "ZDT1 requer pelo menos 2 variáveis"
    meta = META["ZDT1"]
    
    # Primeira função objetivo: f₁(x) = x₁
    f1 = x -> x[1]
    
    # Função auxiliar: g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
    g = x -> 1.0 + 9.0 * sum(x[2:end]) / (n - 1)
    
    # Segunda função objetivo: f₂(x) = g(x) * [1 - √(f₁(x)/g(x))]
    f2 = x -> let
        gx = g(x)
        return gx * (1.0 - sqrt(x[1] / gx))
    end
    
    # Derivada de f₁ em relação a x
    df1_dx = x -> begin
        grad = zeros(length(x))
        grad[1] = 1.0
        return grad
    end
    
    # Derivada de f₂ em relação a x
    df2_dx = x -> begin
        grad = zeros(length(x))
        gx = g(x)
        f1x = f1(x)
        
        # ∂f₂/∂x₁ = -0.5 * g(x) * (f₁(x)/g(x))^(-0.5) * (1/g(x))
        grad[1] = -0.5 * gx * (f1x / gx)^(-0.5) * (1.0 / gx)
        
        # ∂g/∂xᵢ para i ≥ 2
        dg_dxi = 9.0 / (n - 1)
        
        # ∂f₂/∂xᵢ para i ≥ 2
        # = (∂g/∂xᵢ) * (1 - √(f₁/g)) - g * ∂/∂xᵢ(√(f₁/g))
        # = (∂g/∂xᵢ) * (1 - √(f₁/g)) + g * (1/2) * (f₁/g)^(-0.5) * (f₁/g²) * ∂g/∂xᵢ
        for i in 2:length(x)
            term1 = dg_dxi * (1.0 - sqrt(f1x / gx))
            term2 = gx * 0.5 * (f1x / gx)^(-0.5) * (-f1x / gx^2) * dg_dxi
            grad[i] = term1 + term2
        end
        
        return grad
    end
    
    # Jacobiana completa
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']
    
    m = meta[:nobj]
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        [f1, f2];                       # f
        name = meta[:name],             # nome
        origin = meta[:origin],         # origem
        minimize = meta[:minimize],     # minimizar
        has_bounds = meta[:has_bounds], # tem limites
        bounds = (zeros(n), ones(n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = [df1_dx, df2_dx], # jacobiana por linha
        convexity = meta[:convexity]    # convexidade dos objetivos
    )
end


# ZDT2 - não convexa

"""
    ZDT2(n::Int = 30)

Problema ZDT2 com `n` variáveis (default: 30).

Características:
- Número de variáveis: 30 (default, mas pode ser modificado)
- Número de objetivos: 2
- Domínio: [0, 1]^n
- Fronteira de Pareto: f₁ ∈ [0, 1], f₂ = 1 - f₁²
- Fronteira de Pareto não-convexa e contínua
- Objetivos: f₁ é convexo, f₂ é não-convexo

Fórmulas:
- f₁(x) = x₁
- f₂(x) = g(x) * [1 - (f₁(x)/g(x))²]
- g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
"""
function ZDT2(n::Int = 30)
    @assert n >= 2 "ZDT2 requer pelo menos 2 variáveis"
    meta = META["ZDT2"]
    
    # Primeira função objetivo: f₁(x) = x₁
    f1 = x -> x[1]
    
    # Função auxiliar: g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
    g = x -> 1.0 + 9.0 * sum(x[2:end]) / (n - 1)
    
    # Segunda função objetivo: f₂(x) = g(x) * [1 - (f₁(x)/g(x))²]
    f2 = x -> let
        gx = g(x)
        return gx * (1.0 - (x[1] / gx)^2)
    end
    
    # Derivada de f₁ em relação a x
    df1_dx = x -> begin
        grad = zeros(length(x))
        grad[1] = 1.0
        return grad
    end
    
    # Derivada de f₂ em relação a x
    df2_dx = x -> begin
        grad = zeros(length(x))
        gx = g(x)
        f1x = f1(x)
        
        # ∂f₂/∂x₁ = -2 * g(x) * (f₁(x)/g(x)) * (1/g(x))
        grad[1] = -2.0 * gx * (f1x / gx) * (1.0 / gx)
        
        # ∂g/∂xᵢ para i ≥ 2
        dg_dxi = 9.0 / (n - 1)
        
        # ∂f₂/∂xᵢ para i ≥ 2
        # = (∂g/∂xᵢ) * (1 - (f₁/g)²) - g * ∂/∂xᵢ((f₁/g)²)
        # = (∂g/∂xᵢ) * (1 - (f₁/g)²) + g * 2 * (f₁/g) * (f₁/g²) * ∂g/∂xᵢ
        for i in 2:length(x)
            term1 = dg_dxi * (1.0 - (f1x / gx)^2)
            term2 = gx * 2.0 * (f1x / gx) * (-f1x / gx^2) * dg_dxi
            grad[i] = term1 + term2
        end
        
        return grad
    end
    
    # Jacobiana completa
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']
    
    m = meta[:nobj]
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        [f1, f2];                       # f
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (zeros(n), ones(n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = [df1_dx, df2_dx], # jacobiana por linha
        convexity = meta[:convexity]
    )
end


# ZDT3 - descontínua

"""
    ZDT3(n::Int = 30)

Problema ZDT3 com `n` variáveis (default: 30).

Características:
- Número de variáveis: 30 (default, mas pode ser modificado)
- Número de objetivos: 2
- Domínio: [0, 1]^n
- Fronteira de Pareto: descontínua
- Objetivos: f₁ é convexo, f₂ é não-convexo

Fórmulas:
- f₁(x) = x₁
- f₂(x) = g(x) * [1 - √(f₁(x)/g(x)) - (f₁(x)/g(x)) * sin(10π*f₁(x))]
- g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
"""
function ZDT3(n::Int = 30)
    @assert n >= 2 "ZDT3 requer pelo menos 2 variáveis"
    meta = META["ZDT3"]
    
    # Primeira função objetivo: f₁(x) = x₁
    f1 = x -> x[1]
    
    # Função auxiliar: g(x) = 1 + 9 * (∑ᵢ₌₂ⁿ xᵢ) / (n-1)
    g = x -> 1.0 + 9.0 * sum(x[2:end]) / (n - 1)
    
    # Segunda função objetivo: f₂(x) = g(x) * [1 - √(f₁(x)/g(x)) - (f₁(x)/g(x)) * sin(10π*f₁(x))]
    f2 = x -> let
        gx = g(x)
        f1x = x[1]
        ratio = f1x / gx
        return gx * (1.0 - sqrt(ratio) - ratio * sin(10.0 * π * f1x))
    end
    
    # Derivada de f₁ em relação a x
    df1_dx = x -> begin
        grad = zeros(length(x))
        grad[1] = 1.0
        return grad
    end
    
    # Derivada de f₂ em relação a x
    df2_dx = x -> begin
        grad = zeros(length(x))
        gx = g(x)
        f1x = f1(x)
        ratio = f1x / gx
        
        # Termos para ∂f₂/∂x₁
        term1 = -0.5 * gx * ratio^(-0.5) * (1.0 / gx)
        term2 = -gx * (1.0 / gx) * sin(10.0 * π * f1x)
        term3 = -gx * ratio * 10.0 * π * cos(10.0 * π * f1x)
        grad[1] = term1 + term2 + term3
        
        # ∂g/∂xᵢ para i ≥ 2
        dg_dxi = 9.0 / (n - 1)
        
        # Termos para ∂f₂/∂xᵢ, i ≥ 2
        for i in 2:length(x)
            # Termo da derivada do primeiro componente (1)
            t1 = dg_dxi * (1.0 - sqrt(ratio) - ratio * sin(10.0 * π * f1x))
            
            # Termo da derivada do segundo componente (√(f₁/g))
            t2 = gx * 0.5 * ratio^(-0.5) * (-f1x / gx^2) * dg_dxi
            
            # Termo da derivada do terceiro componente ((f₁/g) * sin(10π*f₁))
            t3 = gx * (-f1x / gx^2) * sin(10.0 * π * f1x) * dg_dxi
            
            grad[i] = t1 + t2 + t3
        end
        
        return grad
    end
    
    # Jacobiana completa
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']
    
    m = meta[:nobj]
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        [f1, f2];                       # f
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (zeros(n), ones(n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = [df1_dx, df2_dx], # jacobiana por linha
        convexity = meta[:convexity]
    )
end


# ZDT4 - multimodal

"""
    ZDT4(n::Int = 10)

Problema ZDT4 com `n` variáveis (default: 10).

Características:
- Número de variáveis: 10 (default, mas pode ser modificado)
- Número de objetivos: 2
- Domínio: x₁ ∈ [0, 1], xᵢ ∈ [-5, 5] para i ≥ 2
- Fronteira de Pareto: f₁ ∈ [0, 1], f₂ = 1 - √f₁
- Fronteira de Pareto convexa e contínua
- Multimodal com 219 ótimos locais
- Objetivos: f₁ é convexo, f₂ é não-convexo

Fórmulas:
- f₁(x) = x₁
- f₂(x) = g(x) * [1 - √(f₁(x)/g(x))]
- g(x) = 1 + 10(n-1) + ∑ᵢ₌₂ⁿ [xᵢ² - 10cos(4πxᵢ)]
"""
function ZDT4(n::Int = 10)
    @assert n >= 2 "ZDT4 requer pelo menos 2 variáveis"
    meta = META["ZDT4"]
    
    # Primeira função objetivo: f₁(x) = x₁
    f1 = x -> x[1]
    
    # Função auxiliar: g(x) = 1 + 10(n-1) + ∑ᵢ₌₂ⁿ [xᵢ² - 10cos(4πxᵢ)]
    g = x -> 1.0 + 10.0 * (n - 1) + sum(x[i]^2 - 10.0 * cos(4.0 * π * x[i]) for i in 2:n)
    
    # Segunda função objetivo: f₂(x) = g(x) * [1 - √(f₁(x)/g(x))]
    f2 = x -> let
        gx = g(x)
        return gx * (1.0 - sqrt(x[1] / gx))
    end
    
    # Derivada de f₁ em relação a x
    df1_dx = x -> begin
        grad = zeros(length(x))
        grad[1] = 1.0
        return grad
    end
    
    # Derivada de f₂ em relação a x
    df2_dx = x -> begin
        grad = zeros(length(x))
        gx = g(x)
        f1x = f1(x)
        
        # ∂f₂/∂x₁ = -0.5 * g(x) * (f₁(x)/g(x))^(-0.5) * (1/g(x))
        grad[1] = -0.5 * gx * (f1x / gx)^(-0.5) * (1.0 / gx)
        
        for i in 2:length(x)
            # ∂g/∂xᵢ = 2xᵢ + 10 * 4π * sin(4πxᵢ)
            dg_dxi = 2.0 * x[i] + 40.0 * π * sin(4.0 * π * x[i])
            
            # ∂f₂/∂xᵢ = (∂g/∂xᵢ) * (1 - √(f₁/g)) + g * (1/2) * (f₁/g)^(-0.5) * (f₁/g²) * ∂g/∂xᵢ
            term1 = dg_dxi * (1.0 - sqrt(f1x / gx))
            term2 = gx * 0.5 * (f1x / gx)^(-0.5) * (-f1x / gx^2) * dg_dxi
            grad[i] = term1 + term2
        end
        
        return grad
    end
    
    # Jacobiana completa
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']
    
    # Limites diferentes: x₁ ∈ [0, 1], xᵢ ∈ [-5, 5] para i ≥ 2
    lower = vcat([0.0], fill(-5.0, n-1))
    upper = vcat([1.0], fill(5.0, n-1))
    
    m = meta[:nobj]
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        [f1, f2];                       # f
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (lower, upper),        # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = [df1_dx, df2_dx], # jacobiana por linha
        convexity = meta[:convexity]
    )
end


# ZDT5 - funções discretas (usando representação binária)

# ZDT6 - não uniforme

"""
    ZDT6(n::Int = 10)

Problema ZDT6 com `n` variáveis (default: 10).

Características:
- Número de variáveis: 10 (default, mas pode ser modificado)
- Número de objetivos: 2
- Domínio: [0, 1]^n
- Fronteira de Pareto: não uniforme
- Dificuldade: baixa densidade de soluções perto da fronteira de Pareto
- Objetivos: ambos não-convexos

Fórmulas:
- f₁(x) = 1 - exp(-4x₁) * sin⁶(6πx₁)
- f₂(x) = g(x) * [1 - (f₁(x)/g(x))²]
- g(x) = 1 + 9 * [(∑ᵢ₌₂ⁿ xᵢ) / (n-1)]^0.25
"""
function ZDT6(n::Int = 10)
    @assert n >= 2 "ZDT6 requer pelo menos 2 variáveis"
    meta = META["ZDT6"]
    
    # Primeira função objetivo: f₁(x) = 1 - exp(-4x₁) * sin⁶(6πx₁)
    f1 = x -> 1.0 - exp(-4.0 * x[1]) * sin(6.0 * π * x[1])^6
    
    # Função auxiliar: g(x) = 1 + 9 * [(∑ᵢ₌₂ⁿ xᵢ) / (n-1)]^0.25
    g = x -> 1.0 + 9.0 * (sum(x[2:end]) / (n - 1))^0.25
    
    # Segunda função objetivo: f₂(x) = g(x) * [1 - (f₁(x)/g(x))²]
    f2 = x -> let
        gx = g(x)
        f1x = f1(x)
        return gx * (1.0 - (f1x / gx)^2)
    end
    
    # Derivada de f₁ em relação a x
    df1_dx = x -> begin
        grad = zeros(length(x))
        
        # ∂f₁/∂x₁ = -∂(exp(-4x₁) * sin⁶(6πx₁))/∂x₁
        # = -[(-4) * exp(-4x₁) * sin⁶(6πx₁) + exp(-4x₁) * 6 * sin⁵(6πx₁) * cos(6πx₁) * 6π]
        # = 4 * exp(-4x₁) * sin⁶(6πx₁) - 36π * exp(-4x₁) * sin⁵(6πx₁) * cos(6πx₁)
        sinTerm = sin(6.0 * π * x[1])
        cosTerm = cos(6.0 * π * x[1])
        expTerm = exp(-4.0 * x[1])
        
        grad[1] = 4.0 * expTerm * sinTerm^6 - 36.0 * π * expTerm * sinTerm^5 * cosTerm
        
        return grad
    end
    
    # Derivada de f₂ em relação a x
    df2_dx = x -> begin
        grad = zeros(length(x))
        gx = g(x)
        f1x = f1(x)
        
        # Derivada de f₁ em relação a x₁
        df1_dx1 = df1_dx(x)[1]
        
        # ∂f₂/∂x₁ = -2 * g(x) * (f₁(x)/g(x)) * (∂f₁/∂x₁) / g(x)
        grad[1] = -2.0 * gx * (f1x / gx) * df1_dx1 / gx
        
        # Termo comum para derivadas com respeito a xᵢ, i ≥ 2
        sum_x = sum(x[2:end])
        
        # ∂g/∂xᵢ = 9 * 0.25 * (sum_x / (n-1))^(-0.75) * (1 / (n-1))
        if sum_x > 0
            dg_dxi = 9.0 * 0.25 * (sum_x / (n - 1))^(-0.75) * (1.0 / (n - 1))
        else
            # Evitar divisão por zero se sum_x = 0
            dg_dxi = 0.0
        end
        
        for i in 2:length(x)
            # ∂f₂/∂xᵢ = (∂g/∂xᵢ) * (1 - (f₁/g)²) - g * ∂/∂xᵢ((f₁/g)²)
            # = (∂g/∂xᵢ) * [1 - 3(f₁/g)²]
            
            term = 1.0 - 3.0 * (f1x / gx)^2
            grad[i] = dg_dxi * term
        end
        
        return grad
    end
    
    # Jacobiana completa
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']
    
    m = meta[:nobj]
    return MOProblem(
        n,                              # nvar
        m,                              # nobj
        [f1, f2];                       # f
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (zeros(n), ones(n)),   # limites
        has_jacobian = true,            # tem jacobiana
        jacobian = jacobian,            # jacobiana
        jacobian_by_row = [df1_dx, df2_dx], # jacobiana por linha
        convexity = meta[:convexity]
    )
end 