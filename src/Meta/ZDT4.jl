ZDT4_meta = Dict(
    :nvar => 10,
    :variable_nvar => true,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "ZDT4",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:convex, :non_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_ZDT4_nvar(; n::Integer = 10, kwargs...) = 1 * n + 0
get_ZDT4_nobj(; kwargs...) = 2
get_ZDT4_ncon(; kwargs...) = 0 