"""
    eval_f(prob::AbstractMOProblem, x::AbstractVector)

Avalia todas as funções objetivo do problema `prob` no ponto `x`.
Retorna um vetor com os valores de todas as funções objetivo.
"""
function eval_f(prob::AbstractMOProblem, x::AbstractVector)
    try
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
        return [f(x) for f in prob.f]
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "function_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    eval_hessian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a matriz hessiana do i-ésimo objetivo no ponto `x`.
Retorna uma matriz n×n. Requer hessiana analítica registrada para a instância.
"""
function eval_hessian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    try
        @assert 1 <= i <= prob.nobj "Índice da função objetivo ($i) deve estar entre 1 e $(prob.nobj)"
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"

        if prob.has_hessian
            if !isempty(prob.hessian_by_row)
                return prob.hessian_by_row[i](x)
            elseif !isnothing(prob.hessian)
                return prob.hessian(x)[i]
            end
        end
        error("Hessiana analítica não registrada para o problema '$(prob.name)'.")
    catch e
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)),
                x,
                "hessian_evaluation",
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)
        end
    end
end

"""
    eval_hessian(prob::AbstractMOProblem, x::AbstractVector)

Avalia as matrizes hessianas de todos os objetivos no ponto `x`.
Retorna um vetor de comprimento m, onde cada entrada é uma matriz n×n.
Requer hessiana analítica registrada para a instância.
"""
function eval_hessian(prob::AbstractMOProblem, x::AbstractVector)
    try
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"

        if prob.has_hessian
            if !isnothing(prob.hessian)
                return prob.hessian(x)
            elseif !isempty(prob.hessian_by_row)
                return [prob.hessian_by_row[i](x) for i in 1:prob.nobj]
            end
        end
        error("Hessiana analítica não registrada para o problema '$(prob.name)'.")
    catch e
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)),
                x,
                "hessian_evaluation",
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)
        end
    end
end

"""
    eval_f(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima função objetivo do problema `prob` no ponto `x`.
"""
function eval_f(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    try
        @assert 1 <= i <= prob.nobj "Índice da função objetivo ($i) deve estar entre 1 e $(prob.nobj)"
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
        return prob.f[i](x)
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "function_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    eval_g(prob::AbstractMOProblem, x::AbstractVector)

Avalia todas as funções de restrição do problema `prob` no ponto `x`.
Retorna um vetor com os valores de todas as funções de restrição.
Se o problema não tiver restrições, retorna um vetor vazio.
"""
function eval_g(prob::AbstractMOProblem, x::AbstractVector)
    try
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
        if prob.ncon == 0
            return Float64[]
        else
            return [g(x) for g in prob.g]
        end
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "function_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    eval_g(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima função de restrição do problema `prob` no ponto `x`.
"""
function eval_g(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    try
        @assert prob.ncon > 0 "O problema não possui restrições"
        @assert 1 <= i <= prob.ncon "Índice da função de restrição ($i) deve estar entre 1 e $(prob.ncon)"
        @assert length(x) == prob.nvar "Dimensão de x ($(length(x))) não corresponde ao número de variáveis ($(prob.nvar))"
        return prob.g[i](x)
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "function_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
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
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "function_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
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
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    eval_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima linha da matriz jacobiana (gradiente da i-ésima função objetivo) no ponto `x`.
Retorna um vetor linha com o gradiente da i-ésima função objetivo.
"""
function eval_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
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
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    eval_constraint_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)

Avalia a i-ésima linha da matriz jacobiana das restrições (gradiente da i-ésima restrição) no ponto `x`.
Retorna um vetor linha com o gradiente da i-ésima função de restrição.
"""
function eval_constraint_jacobian_row(prob::AbstractMOProblem, x::AbstractVector, i::Int)
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    finite_difference_jacobian(prob::AbstractMOProblem, x::AbstractVector; h::Real = 1e-8)

Calcula a matriz jacobiana usando diferenças finitas.
Cada coluna j da jacobiana é calculada perturbando a variável x_j.
"""
function finite_difference_jacobian(prob::AbstractMOProblem, x::AbstractVector; h::Real = 1e-8)
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                string(typeof(prob)), 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
end

"""
    finite_difference_gradient(f::Function, x::AbstractVector; h::Real = 1e-8)

Calcula o gradiente da função f usando diferenças finitas.
"""
#TODO: Usar algum pacote que faz diferenças finitas, como FiniteDifferences.jl
function finite_difference_gradient(f::Function, x::AbstractVector; h::Real = 1e-8)
    try
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
    catch e
        # Verificação específica para erros de domínio matemático
        if isa(e, DomainError) || isa(e, InexactError) || isa(e, OverflowError) || isa(e, UndefVarError) || isa(e, BoundsError)
            throw(DomainViolationError(
                "Function", 
                x, 
                "jacobian_evaluation", 
                "Mathematical error during evaluation: $(string(e))"
            ))
        else
            rethrow(e)  # Preservar outros tipos de erro intactos
        end
    end
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
    if prob.has_hessian
        println(io, "  Possui hessiana analítica: Sim")
    else
        println(io, "  Possui hessiana analítica: Não")
    end
end
