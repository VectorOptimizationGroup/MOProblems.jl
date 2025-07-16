"""
    eval_f(prob::AbstractMOProblem, x::AbstractVector)

Avalia todas as funções objetivo do problema `prob` no ponto `x`.
Retorna um vetor com os valores de todas as funções objetivo.
"""
function eval_f(prob::AbstractMOProblem, x::AbstractVector)
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    return [f(x) for f in prob.f]
end

"""
    eval_f(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima função objetivo do problema `prob` no ponto `x`.
"""
function eval_f(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    @assert 1 <= i <= prob.nobj "Índice da função objetivo ($i) deve estar entre 1 e $(prob.nobj)"
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    return prob.f[i](x)
end

"""
    eval_g(prob::AbstractMOProblem, x::AbstractVector)

Avalia todas as funções de restrição do problema `prob` no ponto `x`.
Retorna um vetor com os valores de todas as funções de restrição.
Se o problema não tiver restrições, retorna um vetor vazio.
"""
function eval_g(prob::AbstractMOProblem, x::AbstractVector)
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    if prob.ncon == 0
        return Float64[]
    else
        return [g(x) for g in prob.g]
    end
end

"""
    eval_g(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima função de restrição do problema `prob` no ponto `x`.
"""
function eval_g(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    @assert prob.ncon > 0 "O problema não possui restrições"
    @assert 1 <= i <= prob.ncon "Índice da função de restrição ($i) deve estar entre 1 e $(prob.ncon)"
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    return prob.g[i](x)
end

"""
    has_constraints(prob::AbstractMOProblem) -> Bool

Retorna `true` se o problema possui ao menos uma restrição geral (`ncon > 0`).
Esta função é útil para scripts que precisam distinguir rapidamente
entre problemas com e sem restrições.
"""
has_constraints(prob::AbstractMOProblem) = prob.ncon > 0

"""
    is_feasible(prob::AbstractMOProblem, x::AbstractVector; tol::Real = 1e-6)

Verifica se o ponto `x` é viável para o problema `prob`.
Um ponto é considerado viável se satisfaz todas as restrições do problema,
incluindo limites de variáveis, com uma tolerância `tol`.
"""
function is_feasible(prob::AbstractMOProblem, x::AbstractVector; tol::Real = 1e-6)
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    
    # Verificar limites de variáveis
    if prob.has_bounds
        lvar, uvar = prob.bounds
        for i in 1:prob.nvar
            if x[i] < lvar[i] - tol || x[i] > uvar[i] + tol
                return false
            end
        end
    end
    
    # Se não houver restrições, o ponto é viável
    if prob.ncon == 0
        return true
    end
    
    # Verificar restrições de igualdade
    if prob.has_equalities_only
        for i in 1:prob.ncon
            if abs(prob.g[i](x)) > tol
                return false
            end
        end
    # Verificar restrições de desigualdade
    elseif prob.has_inequalities_only
        for i in 1:prob.ncon
            if prob.g[i](x) > tol
                return false
            end
        end
    # Caso misto: usar vetor constraint_sense
    else
        for i in 1:prob.ncon
            val = prob.g[i](x)
            if prob.constraint_sense[i] === :eq
                if abs(val) > tol
                    return false
                end
            else  # :ineq assume forma g(x) <= 0
                if val > tol
                    return false
                end
            end
        end
    end
    
    return true
end

"""
    eval_jacobian(prob::AbstractMOProblem, x::AbstractVector)

Avalia a matriz jacobiana das funções objetivo no ponto `x`.
A jacobiana é uma matriz m×n, onde m é o número de objetivos e n é o número de variáveis.
Cada linha i da jacobiana é o gradiente da função objetivo i.

Retorna uma matriz com a jacobiana completa.
Se o problema não tiver jacobiana analítica implementada, usa diferenças finitas.
"""
function eval_jacobian(prob::AbstractMOProblem, x::AbstractVector)
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    
    # Usar jacobiana analítica se disponível
    if prob.has_jacobian
        if !isnothing(prob.jacobian)
            return prob.jacobian(x)
        elseif !isempty(prob.jacobian_by_row)
            J = zeros(prob.nobj, prob.nvar)
            for i in 1:prob.nobj
                J[i, :] = prob.jacobian_by_row[i](x)
            end
            return J
        end
    end
    
    # Usar diferenças finitas se jacobiana analítica não estiver disponível
    return finite_difference_jacobian(prob, x)
end

"""
    eval_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima linha da matriz jacobiana (gradiente da i-ésima função objetivo) no ponto `x`.
Retorna um vetor linha com o gradiente da i-ésima função objetivo.
"""
function eval_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    @assert 1 <= i <= prob.nobj "Índice da função objetivo ($i) deve estar entre 1 e $(prob.nobj)"
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    
    # Usar jacobiana analítica se disponível
    if prob.has_jacobian
        if !isempty(prob.jacobian_by_row)
            return prob.jacobian_by_row[i](x)
        elseif !isnothing(prob.jacobian)
            return prob.jacobian(x)[i, :]
        end
    end
    
    # Usar diferenças finitas se jacobiana analítica não estiver disponível
    return finite_difference_gradient(prob.f[i], x)
end

"""
    eval_constraint_jacobian(prob::AbstractMOProblem, x::AbstractVector)

Avalia a matriz jacobiana das funções de restrição no ponto `x`.
A jacobiana é uma matriz p×n, onde p é o número de restrições e n é o número de variáveis.
Cada linha i da jacobiana é o gradiente da função de restrição i.

Retorna uma matriz com a jacobiana completa das restrições.
Se o problema não tiver restrições, retorna uma matriz vazia.
Se o problema não tiver jacobiana analítica implementada, usa diferenças finitas.
"""
function eval_constraint_jacobian(prob::AbstractMOProblem, x::AbstractVector)
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    
    # Se não houver restrições, retornar matriz vazia
    if prob.ncon == 0
        return zeros(0, prob.nvar)
    end
    
    # Usar jacobiana analítica se disponível
    if prob.has_jacobian
        if !isnothing(prob.constraint_jacobian)
            return prob.constraint_jacobian(x)
        elseif !isempty(prob.constraint_jacobian_by_row)
            J = zeros(prob.ncon, prob.nvar)
            for i in 1:prob.ncon
                J[i, :] = prob.constraint_jacobian_by_row[i](x)
            end
            return J
        end
    end
    
    # Usar diferenças finitas se jacobiana analítica não estiver disponível
    J = zeros(prob.ncon, prob.nvar)
    for i in 1:prob.ncon
        J[i, :] = finite_difference_gradient(prob.g[i], x)
    end
    return J
end

"""
    eval_constraint_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima linha da matriz jacobiana das restrições (gradiente da i-ésima restrição) no ponto `x`.
Retorna um vetor linha com o gradiente da i-ésima função de restrição.
"""
function eval_constraint_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    @assert prob.ncon > 0 "O problema não possui restrições"
    @assert 1 <= i <= prob.ncon "Índice da função de restrição ($i) deve estar entre 1 e $(prob.ncon)"
    @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
    
    # Usar jacobiana analítica se disponível
    if prob.has_jacobian
        if !isempty(prob.constraint_jacobian_by_row)
            return prob.constraint_jacobian_by_row[i](x)
        elseif !isnothing(prob.constraint_jacobian)
            return prob.constraint_jacobian(x)[i, :]
        end
    end
    
    # Usar diferenças finitas se jacobiana analítica não estiver disponível
    return finite_difference_gradient(prob.g[i], x)
end

"""
    finite_difference_jacobian(prob::AbstractMOProblem, x::AbstractVector; h::Real = 1e-8)

Calcula a matriz jacobiana usando diferenças finitas.
Cada coluna j da jacobiana é calculada perturbando a variável x_j.
"""
function finite_difference_jacobian(prob::AbstractMOProblem, x::AbstractVector; h::Real = 1e-8)
    n = prob.nvar
    m = prob.nobj
    J = zeros(m, n)
    
    # Avaliar f(x)
    fx = eval_f(prob, x)
    
    # Para cada variável, calcular a derivada parcial
    for j in 1:n
        # Criar vetor perturbado
        xj = copy(x)
        xj[j] += h
        
        # Avaliar f(x + h*e_j)
        fxj = eval_f(prob, xj)
        
        # Calcular diferença finita
        J[:, j] = (fxj - fx) / h
    end
    
    return J
end

"""
    finite_difference_gradient(f::Function, x::AbstractVector; h::Real = 1e-8)

Calcula o gradiente da função f usando diferenças finitas.
"""
#TODO: Usar algum pacote que faz diferenças finitas, como FiniteDifferences.jl
function finite_difference_gradient(f::Function, x::AbstractVector; h::Real = 1e-8)
    n = length(x)
    grad = zeros(n)
    
    # Avaliar f(x)
    fx = f(x)
    
    # Para cada variável, calcular a derivada parcial
    for j in 1:n
        # Criar vetor perturbado
        xj = copy(x)
        xj[j] += h
        
        # Avaliar f(x + h*e_j)
        fxj = f(xj)
        
        # Calcular diferença finita
        grad[j] = (fxj - fx) / h
    end
    
    return grad
end

"""
    Base.show(io::IO, prob::MOProblem)

Método para mostrar informações sobre o problema.
"""
function Base.show(io::IO, prob::MOProblem)
    println(io, "MOProblem: $(prob.name)")
    println(io, "  Variáveis: $(prob.nvar) ($(prob.variable_nvar ? "variável" : "fixo"))")
    println(io, "  Objetivos: $(prob.nobj) ($(prob.variable_nobj ? "variável" : "fixo"))")
    println(io, "  Restrições: $(prob.ncon) ($(prob.variable_ncon ? "variável" : "fixo"))")
    println(io, "  Tipo de otimização: $(prob.minimize ? "minimização" : "maximização")")
    println(io, "  Tipo de objetivos: $(prob.m_objtype)")
    println(io, "  Tipo de restrições: $(prob.contype)")
    println(io, "  Origem: $(prob.origin)")
    if prob.has_bounds
        println(io, "  Possui restrições de limite: Sim")
    else
        println(io, "  Possui restrições de limite: Não")
    end
    if prob.has_jacobian
        println(io, "  Possui jacobiana analítica: Sim")
    else
        println(io, "  Possui jacobiana analítica: Não (usa diferenças finitas)")
    end
end

"""
    get_convexity(problem::AbstractMOProblem)

Retorna informações sobre a convexidade de cada função objetivo.

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo

# Retorno
Um vetor de símbolos com a convexidade de cada objetivo (`:strictly_convex`, `:convex`, `:non_convex` ou `:unknown`).
"""
function get_convexity(problem::AbstractMOProblem)
    return problem.convexity
end

"""
    get_convexity(problem::AbstractMOProblem, i::Int)

Retorna a informação de convexidade para a i-ésima função objetivo.

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo
- `i::Int`: índice da função objetivo

# Retorno
Um símbolo indicando a convexidade do i-ésimo objetivo (`:strictly_convex`, `:convex`, `:non_convex` ou `:unknown`).
"""
function get_convexity(problem::AbstractMOProblem, i::Int)
    @assert 1 <= i <= problem.nobj "Índice de função objetivo inválido: $i. Deve estar entre 1 e $(problem.nobj)"
    return problem.convexity[i]
end

"""
    is_strictly_convex(problem::AbstractMOProblem, i::Int)

Verifica se a i-ésima função objetivo é estritamente convexa.

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo
- `i::Int`: índice da função objetivo

# Retorno
`true` se a função objetivo for estritamente convexa, `false` caso contrário.
"""
function is_strictly_convex(problem::AbstractMOProblem, i::Int)
    @assert 1 <= i <= problem.nobj "Índice de função objetivo inválido: $i. Deve estar entre 1 e $(problem.nobj)"
    return problem.convexity[i] === :strictly_convex
end

"""
    is_convex(problem::AbstractMOProblem, i::Int)

Verifica se a i-ésima função objetivo é convexa (não necessariamente estritamente).

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo
- `i::Int`: índice da função objetivo

# Retorno
`true` se a função objetivo for convexa, `false` caso contrário.
"""
function is_convex(problem::AbstractMOProblem, i::Int)
    @assert 1 <= i <= problem.nobj "Índice de função objetivo inválido: $i. Deve estar entre 1 e $(problem.nobj)"
    return problem.convexity[i] === :convex || problem.convexity[i] === :strictly_convex
end

"""
    all_strictly_convex(problem::AbstractMOProblem)

Verifica se todas as funções objetivo são estritamente convexas.

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo

# Retorno
`true` se todas as funções objetivo forem estritamente convexas, `false` caso contrário.
"""
function all_strictly_convex(problem::AbstractMOProblem)
    return all(problem.convexity .=== :strictly_convex)
end

"""
    all_convex(problem::AbstractMOProblem)

Verifica se todas as funções objetivo são convexas (não necessariamente estritamente).

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo

# Retorno
`true` se todas as funções objetivo forem convexas, `false` caso contrário.
"""
function all_convex(problem::AbstractMOProblem)
    return all(c -> c === :convex || c === :strictly_convex, problem.convexity)
end

"""
    any_strictly_convex(problem::AbstractMOProblem)

Verifica se pelo menos uma das funções objetivo é estritamente convexa.

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo

# Retorno
`true` se pelo menos uma função objetivo for estritamente convexa, `false` caso contrário.
"""
function any_strictly_convex(problem::AbstractMOProblem)
    return any(problem.convexity .=== :strictly_convex)
end

"""
    any_convex(problem::AbstractMOProblem)

Verifica se pelo menos uma das funções objetivo é convexa (não necessariamente estritamente).

# Argumentos
- `problem::AbstractMOProblem`: o problema de otimização multiobjetivo

# Retorno
`true` se pelo menos uma função objetivo for convexa, `false` caso contrário.
"""
function any_convex(problem::AbstractMOProblem)
    return any(c -> c === :convex || c === :strictly_convex, problem.convexity)
end

# === Métodos adicionais que operam diretamente sobre os metadados (META) ===

"""
    get_convexity(name::String)

Retorna o vetor de convexidade salvo em `META` para o problema dado.
"""
function get_convexity(name::String)
    return META[name][:convexity]
end

"""
    get_convexity(name::String, i::Int)
"""
function get_convexity(name::String, i::Int)
    return META[name][:convexity][i]
end

is_strictly_convex(name::String, i::Int) = META[name][:convexity][i] === :strictly_convex
is_convex(name::String, i::Int)         = begin
    c = META[name][:convexity][i]
    c === :convex || c === :strictly_convex
end
all_strictly_convex(name::String) = all(c -> c === :strictly_convex, META[name][:convexity])
all_convex(name::String)          = all(c -> c === :convex || c === :strictly_convex, META[name][:convexity])
any_strictly_convex(name::String) = any(c -> c === :strictly_convex, META[name][:convexity])
any_convex(name::String)          = any(c -> c === :convex || c === :strictly_convex, META[name][:convexity]) 

# === Função de conveniência para obter problemas ===

"""
    get_problem(name::String, args...; kwargs...)

Obtém um problema pelo nome, instanciando-o se necessário.
Esta função é um alias para `instantiate(name, args...; kwargs...)`.

**Interface Recomendada**: Para melhor performance e clareza, prefira usar construtores diretos 
quando possível (ex: `ZDT1()`, `AP1()`, etc.) em vez de instanciação por nome.

# Argumentos
- `name::String`: nome do problema a ser obtido
- `args...`: argumentos posicionais para o construtor do problema
- `kwargs...`: argumentos nomeados para o construtor do problema

# Retorno
Uma instância do problema especificado.

# Exemplo
```julia
# Forma recomendada: construtores diretos
zdt1 = ZDT1()        # 30 variáveis (padrão)
zdt1_50 = ZDT1(50)   # 50 variáveis
ap1 = AP1()          # Problema AP1

# Forma por nome (compatibilidade)
zdt1_alt = get_problem("ZDT1")
zdt1_50_alt = get_problem("ZDT1", 50)

# Consultar problemas disponíveis
names = get_problem_names()
convex_problems = filter_problems(any_convex=true)
```
"""
function get_problem(name::String, args...; kwargs...)
    return instantiate(name, args...; kwargs...)
end 