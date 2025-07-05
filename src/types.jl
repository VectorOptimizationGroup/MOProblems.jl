"""
    AbstractVectorFunction

Tipo abstrato para funções vetoriais.
"""
abstract type AbstractVectorFunction end

"""
    AbstractMOProblem

Tipo abstrato para problemas de otimização multiobjetivo.
"""
abstract type AbstractMOProblem <: AbstractVectorFunction end

"""
    MOProblem{T}

Estrutura de dados para problemas de otimização multiobjetivo.

# Campos
- `nvar::Int`: número de variáveis
- `variable_nvar::Bool`: true se o número de variáveis pode ser modificado
- `nobj::Int`: número de objetivos
- `variable_nobj::Bool`: true se o número de objetivos pode ser modificado
- `ncon::Int`: número de restrições gerais
- `variable_ncon::Bool`: true se o número de restrições pode ser modificado
- `minimize::Bool`: true se otimizar == minimizar
- `name::String`: nome do problema
- `has_equalities_only::Bool`: true se o problema tem restrições e todas são de igualdade
- `has_inequalities_only::Bool`: true se o problema tem restrições e todas são de desigualdade
- `has_bounds::Bool`: true se o problema tem restrições de limite
- `m_objtype::Symbol`: tipo de múltiplos objetivos, em [:linear, :nonlinear, :mixed, :other]
- `contype::Symbol`: tipo de restrição, em [:unconstrained, :linear, :quadratic, :general]
- `origin::Symbol`: origem do problema, em [:academic, :modelling, :real, :unknown]
- `f::Vector{Function}`: funções objetivo
- `g::Vector{Function}`: funções de restrição (quando aplicável)
- `bounds::Tuple{Vector{T}, Vector{T}}`: limites (inferior, superior) das variáveis
- `has_jacobian::Bool`: true se o problema tem jacobiana analítica implementada
- `jacobian::Union{Nothing, Function}`: função que retorna a matriz jacobiana completa (quando implementada)
- `jacobian_by_row::Vector{Function}`: funções que retornam cada linha da jacobiana (gradientes das funções objetivo)
- `constraint_jacobian::Union{Nothing, Function}`: função que retorna a jacobiana das restrições (quando implementada)
- `constraint_jacobian_by_row::Vector{Function}`: funções que retornam cada linha da jacobiana de restrições
- `constraint_sense::Vector{Symbol}`: um vetor com `:eq` ou `:ineq` indicando o tipo de cada restrição (apenas relevante quando há mistura)
- `convexity::Vector{Symbol}`: tipo de convexidade para cada função objetivo, valores em [:strictly_convex, :convex, :non_convex, :unknown]
"""
mutable struct MOProblem{T <: AbstractFloat} <: AbstractMOProblem
    nvar::Int
    variable_nvar::Bool
    nobj::Int
    variable_nobj::Bool
    ncon::Int
    variable_ncon::Bool
    minimize::Bool
    name::String
    has_equalities_only::Bool
    has_inequalities_only::Bool
    has_bounds::Bool
    m_objtype::Symbol
    contype::Symbol
    origin::Symbol
    f::Vector{Function}
    g::Vector{Function}
    bounds::Tuple{Vector{T}, Vector{T}}
    has_jacobian::Bool
    jacobian::Union{Nothing, Function}
    jacobian_by_row::Vector{Function}
    constraint_jacobian::Union{Nothing, Function}
    constraint_jacobian_by_row::Vector{Function}
    constraint_sense::Vector{Symbol}
    convexity::Vector{Symbol}
    
    # Construtor interno
    function MOProblem{T}(
        nvar::Int,
        nobj::Int, 
        f::Vector{Function};
        variable_nvar::Bool = false,
        variable_nobj::Bool = false,
        ncon::Int = 0,
        variable_ncon::Bool = false,
        minimize::Bool = true,
        name::String = "Unnamed MO Problem",
        has_equalities_only::Bool = false,
        has_inequalities_only::Bool = ncon > 0,
        has_bounds::Bool = false,
        m_objtype::Symbol = :nonlinear,
        contype::Symbol = ncon == 0 ? :unconstrained : :general,
        origin::Symbol = :unknown,
        g::Vector{Function} = Function[],
        bounds::Tuple{Vector{T}, Vector{T}} = (fill(T(-Inf), nvar), fill(T(Inf), nvar)),
        has_jacobian::Bool = false,
        jacobian::Union{Nothing, Function} = nothing,
        jacobian_by_row::Vector{Function} = Function[],
        constraint_jacobian::Union{Nothing, Function} = nothing,
        constraint_jacobian_by_row::Vector{Function} = Function[],
        constraint_sense::Vector{Symbol} = Symbol[],
        convexity::Vector{Symbol} = fill(:unknown, nobj)
    ) where {T <: AbstractFloat}
        @assert length(f) == nobj "Número de funções objetivo ($(length(f))) deve ser igual a nobj ($nobj)"
        @assert length(g) == ncon "Número de funções de restrição ($(length(g))) deve ser igual a ncon ($ncon)"
        @assert length(bounds[1]) == nvar "Número de limites inferiores ($(length(bounds[1]))) deve ser igual a nvar ($nvar)"
        @assert length(bounds[2]) == nvar "Número de limites superiores ($(length(bounds[2]))) deve ser igual a nvar ($nvar)"
        @assert m_objtype in [:linear, :nonlinear, :mixed, :other] "m_objtype deve ser um de: :linear, :nonlinear, :mixed, :other"
        @assert contype in [:unconstrained, :linear, :quadratic, :general] "contype deve ser um de: :unconstrained, :linear, :quadratic, :general"
        @assert origin in [:academic, :modelling, :real, :unknown] "origin deve ser um de: :academic, :modelling, :real, :unknown"
        @assert length(convexity) == nobj "Número de informações de convexidade ($(length(convexity))) deve ser igual a nobj ($nobj)"
        
        # Verificar valores válidos para convexity
        valid_convexity = [:strictly_convex, :convex, :non_convex, :unknown]
        for c in convexity
            @assert c in valid_convexity "Valor de convexidade deve ser um de: $valid_convexity"
        end
        
        # Verificar consistência de jacobian e jacobian_by_row
        if has_jacobian
            if isnothing(jacobian) && isempty(jacobian_by_row)
                @warn "Campo has_jacobian é verdadeiro, mas nenhuma função jacobiana foi fornecida"
                has_jacobian = false
            elseif !isempty(jacobian_by_row) && length(jacobian_by_row) != nobj
                @warn "O número de funções de gradiente ($(length(jacobian_by_row))) deve ser igual a nobj ($nobj)"
                jacobian_by_row = Function[]
                has_jacobian = false
            end
        end
        
        # Verificar consistência de constraint_jacobian e constraint_jacobian_by_row
        if ncon > 0 && has_jacobian
            if isnothing(constraint_jacobian) && isempty(constraint_jacobian_by_row)
                @warn "O problema tem restrições, mas nenhuma função de gradiente de restrição foi fornecida"
            elseif !isempty(constraint_jacobian_by_row) && length(constraint_jacobian_by_row) != ncon
                @warn "O número de funções de gradiente de restrição ($(length(constraint_jacobian_by_row))) deve ser igual a ncon ($ncon)"
                constraint_jacobian_by_row = Function[]
            end
        end
        
        # Preparar vetor constraint_sense
        if ncon == 0
            constraint_sense = Symbol[]
        elseif has_equalities_only
            constraint_sense = fill(:eq, ncon)
        elseif has_inequalities_only
            constraint_sense = fill(:ineq, ncon)
        else
            @assert length(constraint_sense) == ncon "constraint_sense deve ter comprimento ncon quando houver restrições mistas"
            @assert all(s -> s in (:eq, :ineq), constraint_sense) "constraint_sense deve conter apenas :eq ou :ineq"
        end
        
        return new{T}(
            nvar, variable_nvar, nobj, variable_nobj, ncon, variable_ncon,
            minimize, name, has_equalities_only, has_inequalities_only, has_bounds,
            m_objtype, contype, origin, f, g, bounds, 
            has_jacobian, jacobian, jacobian_by_row, constraint_jacobian, constraint_jacobian_by_row,
            constraint_sense,
            convexity
        )
    end
end

# Construtor conveniente para criar um MOProblem com o tipo T inferido dos limites
function MOProblem(
    nvar::Int,
    nobj::Int, 
    f::Vector{Function};
    variable_nvar::Bool = false,
    variable_nobj::Bool = false,
    ncon::Int = 0,
    variable_ncon::Bool = false,
    minimize::Bool = true,
    name::String = "Unnamed MO Problem",
    has_equalities_only::Bool = false,
    has_inequalities_only::Bool = ncon > 0,
    has_bounds::Bool = false,
    m_objtype::Symbol = :nonlinear,
    contype::Symbol = ncon == 0 ? :unconstrained : :general,
    origin::Symbol = :unknown,
    g::Vector{Function} = Function[],
    bounds::Tuple{Vector{T}, Vector{T}} = (fill(-Inf, nvar), fill(Inf, nvar)),
    has_jacobian::Bool = false,
    jacobian::Union{Nothing, Function} = nothing,
    jacobian_by_row::Vector{Function} = Function[],
    constraint_jacobian::Union{Nothing, Function} = nothing,
    constraint_jacobian_by_row::Vector{Function} = Function[],
    constraint_sense::Vector{Symbol} = Symbol[],
    convexity::Vector{Symbol} = fill(:unknown, nobj)
) where {T <: AbstractFloat}
    return MOProblem{T}(
        nvar, nobj, f;
        variable_nvar = variable_nvar,
        variable_nobj = variable_nobj,
        ncon = ncon,
        variable_ncon = variable_ncon,
        minimize = minimize,
        name = name,
        has_equalities_only = has_equalities_only,
        has_inequalities_only = has_inequalities_only,
        has_bounds = has_bounds,
        m_objtype = m_objtype,
        contype = contype,
        origin = origin,
        g = g,
        bounds = bounds,
        has_jacobian = has_jacobian,
        jacobian = jacobian,
        jacobian_by_row = jacobian_by_row,
        constraint_jacobian = constraint_jacobian,
        constraint_jacobian_by_row = constraint_jacobian_by_row,
        constraint_sense = constraint_sense,
        convexity = convexity
    )
end 