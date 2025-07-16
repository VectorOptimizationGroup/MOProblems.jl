"""
    Funções de registro

Funções para registro e consulta de problemas de otimização multiobjetivo.
"""

# Lista de problemas registrados
const PROBLEMS = Dict{String, AbstractMOProblem}()

"""
    register_problem(problem::AbstractMOProblem)

Registra um problema no registro global.

# Argumentos
- `problem::AbstractMOProblem`: o problema a ser registrado
"""
function register_problem(problem::AbstractMOProblem)
    global PROBLEMS
    if haskey(PROBLEMS, problem.name)
        @warn "Problema com nome '$(problem.name)' já existe no registro. Substituindo..."
    end
    PROBLEMS[problem.name] = problem
    # Atualizar META para refletir possíveis mudanças / instância dinâmica
    if problem isa MOProblem
        META[problem.name] = meta_from_problem(problem)
    end
    return nothing
end

"""
    get_problems()                -> Vector{MOProblem}
    get_problems(name::String)    -> Union{MOProblem, Nothing}

**DEPRECATED**: Esta função está sendo descontinuada. Use `get_problem_names()` para consultar 
nomes de problemas disponíveis e `get_problem(name)` ou construtores diretos (ex: `ZDT1()`) 
para instanciar problemas.

Sem argumentos: devolve todas as instâncias registradas em `PROBLEMS`.
Com um `name::String`: devolve a instância correspondente ou `nothing`
caso não exista.
"""
get_problems() = begin
    @warn "get_problems() is deprecated. Use get_problem_names() for listing available problems and get_problem(name) or direct constructors (e.g., ZDT1()) for instantiation."
    collect(values(PROBLEMS))
end

function get_problems(name::String)
    @warn "get_problems(name) is deprecated. Use get_problem(name) or direct constructors (e.g., ZDT1()) instead."
    return get(PROBLEMS, name, nothing)
end

"""
    get_problem_names()

Retorna os nomes de todos os problemas registrados.

# Retorno
Uma lista com os nomes de todos os problemas registrados.
"""
function get_problem_names()
    return collect(keys(META))
end

"""
    filter_problems(;
        name_pattern::Union{Nothing, String, Regex} = nothing,
        min_vars::Int = 0,
        max_vars::Int = typemax(Int),
        min_objs::Int = 0,
        max_objs::Int = typemax(Int),
        min_cons::Int = 0,
        max_cons::Int = typemax(Int),
        has_constraints::Union{Nothing, Bool} = nothing,
        has_bounds::Union{Nothing, Bool} = nothing,
        has_jacobian::Union{Nothing, Bool} = nothing,
        m_objtype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
        contype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
        origin::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
        any_strictly_convex::Union{Nothing, Bool} = nothing,
        all_strictly_convex::Union{Nothing, Bool} = nothing,
        any_convex::Union{Nothing, Bool} = nothing,
        all_convex::Union{Nothing, Bool} = nothing,
        all_non_convex::Union{Nothing, Bool} = nothing
    )

Filtra problemas com base em critérios específicos.

# Argumentos
- `name_pattern::Union{Nothing, String, Regex}`: padrão para o nome do problema
- `min_vars::Int`: número mínimo de variáveis
- `max_vars::Int`: número máximo de variáveis
- `min_objs::Int`: número mínimo de objetivos
- `max_objs::Int`: número máximo de objetivos
- `min_cons::Int`: número mínimo de restrições
- `max_cons::Int`: número máximo de restrições
- `has_constraints::Union{Nothing, Bool}`: se o problema tem restrições
- `has_bounds::Union{Nothing, Bool}`: se o problema tem limites
- `has_jacobian::Union{Nothing, Bool}`: se o problema tem jacobiana analítica
- `m_objtype::Union{Nothing, Symbol, Vector{Symbol}}`: tipo de múltiplos objetivos
- `contype::Union{Nothing, Symbol, Vector{Symbol}}`: tipo de restrição
- `origin::Union{Nothing, Symbol, Vector{Symbol}}`: origem do problema
- `any_strictly_convex::Union{Nothing, Bool}`: se algum objetivo é estritamente convexo
- `all_strictly_convex::Union{Nothing, Bool}`: se todos os objetivos são estritamente convexos
- `any_convex::Union{Nothing, Bool}`: se algum objetivo é convexo
- `all_convex::Union{Nothing, Bool}`: se todos os objetivos são convexos
- `all_non_convex::Union{Nothing, Bool}`: se todos os objetivos são não convexos

# Retorno
Uma lista com os problemas que satisfazem os critérios de filtragem.
"""
function filter_problems(;
    name_pattern::Union{Nothing, String, Regex} = nothing,
    min_vars::Int = 0,
    max_vars::Int = typemax(Int),
    min_objs::Int = 0,
    max_objs::Int = typemax(Int),
    min_cons::Int = 0,
    max_cons::Int = typemax(Int),
    has_constraints::Union{Nothing, Bool} = nothing,
    has_bounds::Union{Nothing, Bool} = nothing,
    has_jacobian::Union{Nothing, Bool} = nothing,
    m_objtype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
    contype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
    origin::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
    any_strictly_convex::Union{Nothing, Bool} = nothing,
    all_strictly_convex::Union{Nothing, Bool} = nothing,
    any_convex::Union{Nothing, Bool} = nothing,
    all_convex::Union{Nothing, Bool} = nothing,
    all_non_convex::Union{Nothing, Bool} = nothing
)
    names = String[]
    for (pname, meta) in META
        # Filtrar por nome
        if !isnothing(name_pattern)
            if name_pattern isa Regex
                if !occursin(name_pattern, pname)
                    continue
                end
            else
                if !occursin(String(name_pattern), pname)
                    continue
                end
            end
        end
        
        # Filtrar por número de variáveis
        nvar = meta[:nvar]
        if !(min_vars <= nvar <= max_vars)
            continue
        end
        
        # Filtrar por número de objetivos
        nobj = meta[:nobj]
        if !(min_objs <= nobj <= max_objs)
            continue
        end
        
        # Filtrar por número de restrições
        ncon = meta[:ncon]
        if !(min_cons <= ncon <= max_cons)
            continue
        end
        
        # Filtrar por presença de restrições
        if !isnothing(has_constraints) && (has_constraints != (ncon > 0))
            continue
        end
        
        # Filtrar por presença de limites
        if !isnothing(has_bounds) && (has_bounds != meta[:has_bounds])
            continue
        end
        
        # Filtrar por presença de jacobiana
        if !isnothing(has_jacobian) && (has_jacobian != get(meta, :has_jacobian, false))
            continue
        end
        
        # Filtrar por tipo de objetivos múltiplos
        if !isnothing(m_objtype)
            if m_objtype isa Symbol
                if meta[:m_objtype] != m_objtype
                    continue
                end
            else
                if !(meta[:m_objtype] in m_objtype)
                    continue
                end
            end
        end
        
        # Filtrar por tipo de restrição
        if !isnothing(contype)
            if contype isa Symbol
                if meta[:contype] != contype
                    continue
                end
            else
                if !(meta[:contype] in contype)
                    continue
                end
            end
        end
        
        # Filtrar por origem
        if !isnothing(origin)
            if origin isa Symbol
                if meta[:origin] != origin
                    continue
                end
            else
                if !(meta[:origin] in origin)
                    continue
                end
            end
        end
        
        # Filtrar por convexidade
        convexity_vec = meta[:convexity]
        
        if !isnothing(any_strictly_convex)
            # Verificar se pelo menos um objetivo é estritamente convexo
            has_strict = any(c -> c === :strictly_convex, convexity_vec)
            if any_strictly_convex != has_strict
                continue
            end
        end
        
        if !isnothing(all_strictly_convex)
            # Verificar se todos os objetivos são estritamente convexos
            all_strict = all(c -> c === :strictly_convex, convexity_vec)
            if all_strictly_convex != all_strict
                continue
            end
        end
        
        if !isnothing(any_convex)
            # Verificar se pelo menos um objetivo é convexo
            has_convex = any(c -> c === :convex || c === :strictly_convex, convexity_vec)
            if any_convex != has_convex
                continue
            end
        end
        
        if !isnothing(all_convex)
            # Verificar se todos os objetivos são convexos
            all_conv = all(c -> c === :convex || c === :strictly_convex, convexity_vec)
            if all_convex != all_conv
                continue
            end
        end
        
        if !isnothing(all_non_convex)
            # Verificar se todos os objetivos são não convexos
            all_non_conv = all(c -> c === :non_convex, convexity_vec)
            if all_non_convex != all_non_conv
                continue
            end
        end
        
        push!(names, pname)
    end
    
    return names
end

"""
    meta_from_problem(prob::MOProblem)

Gera um `Dict` contendo metadados essenciais a partir de um objeto `MOProblem`.
"""
function meta_from_problem(prob::MOProblem)
    return Dict(
        :nvar => prob.nvar,
        :variable_nvar => prob.variable_nvar,
        :nobj => prob.nobj,
        :variable_nobj => prob.variable_nobj,
        :ncon => prob.ncon,
        :variable_ncon => prob.variable_ncon,
        :minimize => prob.minimize,
        :name => prob.name,
        :has_equalities_only => prob.has_equalities_only,
        :has_inequalities_only => prob.has_inequalities_only,
        :has_bounds => prob.has_bounds,
        :m_objtype => prob.m_objtype,
        :contype => prob.contype,
        :origin => prob.origin,
        :has_jacobian => prob.has_jacobian,
        :convexity => prob.convexity,
    )
end

# -------------------------------------------------------
# Instanciação sob demanda
# -------------------------------------------------------
"""
    instantiate(name::String, args...; kwargs...)

Cria e retorna o objeto `MOProblem` correspondente a `name`, passando
`args` e `kwargs` para o construtor.  Após a criação, o problema é
registrado com `register_problem` e seu metadado é adicionado a `META`.
"""
function instantiate(name::String, args...; kwargs...)
    sym = Symbol(name)
    if !isdefined(@__MODULE__, sym)
        # Tentar incluir arquivo por convenção problems/<lowercase>.jl
        file_path = joinpath(@__DIR__, "problems", lowercase(string(sym)) * ".jl")
        if isfile(file_path)
            include(file_path)
        end
    end
    @assert isdefined(@__MODULE__, sym) "Construtor $(name) não encontrado. Certifique-se de que o problema exista."
    constructor = getfield(@__MODULE__, sym)
    prob = constructor(args...; kwargs...)
    register_problem(prob)
    return prob
end 