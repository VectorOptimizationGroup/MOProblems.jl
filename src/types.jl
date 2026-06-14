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
- `minimize::Bool`: true se otimizar == minimizar
- `name::String`: nome do problema
- `has_bounds::Bool`: true se o problema tem restrições de limite
- `m_objtype::Symbol`: tipo de múltiplos objetivos, em [:linear, :nonlinear, :mixed, :other]
- `origin::Symbol`: origem do problema, em [:academic, :modelling, :real, :unknown]
- `f::Vector{Function}`: funções objetivo
- `bounds::Tuple{Vector{T}, Vector{T}}`: limites (inferior, superior) das variáveis
- `has_jacobian::Bool`: true se o problema tem jacobiana analítica implementada
- `jacobian::Union{Nothing, Function}`: função que retorna a matriz jacobiana completa (quando implementada)
- `jacobian_by_row::Vector{Function}`: funções que retornam cada linha da jacobiana (gradientes das funções objetivo)
- `has_hessian::Bool`: true se o problema tem hessiana analítica implementada
- `hessian::Union{Nothing, Function}`: função que retorna todas as hessianas (por objetivo) em `x`
- `hessian_by_row::Vector{Function}`: funções que retornam a hessiana (matriz n×n) de cada objetivo
- `convexity::Vector{Symbol}`: tipo de convexidade para cada função objetivo, valores em [:strictly_convex, :convex, :non_convex, :unknown]
"""
mutable struct MOProblem{T <: AbstractFloat} <: AbstractMOProblem
    nvar::Int
    variable_nvar::Bool
    nobj::Int
    variable_nobj::Bool
    minimize::Bool
    name::String
    has_bounds::Bool
    m_objtype::Symbol
    origin::Symbol
    f::Vector{Function}
    bounds::Tuple{Vector{T}, Vector{T}}
    has_jacobian::Bool
    jacobian::Union{Nothing, Function}
    jacobian_by_row::Vector{Function}
    has_hessian::Bool
    hessian::Union{Nothing, Function}
    hessian_by_row::Vector{Function}
    convexity::Vector{Symbol}
    
    # Construtor interno
    function MOProblem{T}(
        nvar::Int,
        nobj::Int, 
        f::Vector{Function};
        variable_nvar::Bool = false,
        variable_nobj::Bool = false,
        minimize::Bool = true,
        name::String = "Unnamed MO Problem",
        has_bounds::Bool = false,
        m_objtype::Symbol = :nonlinear,
        origin::Symbol = :unknown,
        bounds::Tuple{Vector{T}, Vector{T}} = (fill(T(-Inf), nvar), fill(T(Inf), nvar)),
        has_jacobian::Bool = false,
        jacobian::Union{Nothing, Function} = nothing,
        jacobian_by_row::Vector{Function} = Function[],
        has_hessian::Bool = false,
        hessian::Union{Nothing, Function} = nothing,
        hessian_by_row::Vector{Function} = Function[],
        convexity::Vector{Symbol} = fill(:unknown, nobj)
    ) where {T <: AbstractFloat}
        @assert length(f) == nobj "Número de funções objetivo ($(length(f))) deve ser igual a nobj ($nobj)"
        @assert length(bounds[1]) == nvar "Número de limites inferiores ($(length(bounds[1]))) deve ser igual a nvar ($nvar)"
        @assert length(bounds[2]) == nvar "Número de limites superiores ($(length(bounds[2]))) deve ser igual a nvar ($nvar)"
        @assert m_objtype in [:linear, :nonlinear, :mixed, :other] "m_objtype deve ser um de: :linear, :nonlinear, :mixed, :other"
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
        
        # Verificar consistência de hessian e hessian_by_row
        if has_hessian
            if isnothing(hessian) && isempty(hessian_by_row)
                @warn "Campo has_hessian é verdadeiro, mas nenhuma função hessiana foi fornecida"
                has_hessian = false
            elseif !isempty(hessian_by_row) && length(hessian_by_row) != nobj
                @warn "O número de funções de hessiana ($(length(hessian_by_row))) deve ser igual a nobj ($nobj)"
                hessian_by_row = Function[]
                has_hessian = false
            end
        end
        
        return new{T}(
            nvar, variable_nvar, nobj, variable_nobj,
            minimize, name, has_bounds,
            m_objtype, origin, f, bounds, 
            has_jacobian, jacobian, jacobian_by_row,
            has_hessian, hessian, hessian_by_row,
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
    minimize::Bool = true,
    name::String = "Unnamed MO Problem",
    has_bounds::Bool = false,
    m_objtype::Symbol = :nonlinear,
    origin::Symbol = :unknown,
    bounds::Tuple{Vector{T}, Vector{T}} = (fill(-Inf, nvar), fill(Inf, nvar)),
    has_jacobian::Bool = false,
    jacobian::Union{Nothing, Function} = nothing,
    jacobian_by_row::Vector{Function} = Function[],
    has_hessian::Bool = false,
    hessian::Union{Nothing, Function} = nothing,
    hessian_by_row::Vector{Function} = Function[],
    convexity::Vector{Symbol} = fill(:unknown, nobj)
) where {T <: AbstractFloat}
    return MOProblem{T}(
        nvar, nobj, f;
        variable_nvar = variable_nvar,
        variable_nobj = variable_nobj,
        minimize = minimize,
        name = name,
        has_bounds = has_bounds,
        m_objtype = m_objtype,
        origin = origin,
        bounds = bounds,
        has_jacobian = has_jacobian,
        jacobian = jacobian,
        jacobian_by_row = jacobian_by_row,
        has_hessian = has_hessian,
        hessian = hessian,
        hessian_by_row = hessian_by_row,
        convexity = convexity
    )
end

struct DomainViolationError <: Exception
    problem_name::String
    point::Vector{<:AbstractFloat}
    violation_type::String  # "bounds" ou "constraints"
    details::String
end

# Método para exibir a exceção de forma informativa
function Base.showerror(io::IO, e::DomainViolationError)
    print(io, "DomainViolationError: Problem '$(e.problem_name)' cannot be evaluated at point $(e.point)")
    print(io, "\nViolation type: $(e.violation_type)")
    if !isempty(e.details)
        print(io, "\nDetails: $(e.details)")
    end
end