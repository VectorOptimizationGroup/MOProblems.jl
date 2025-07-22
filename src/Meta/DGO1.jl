DGO1_meta = Dict(
    :nvar => 1,
    :variable_nvar => false,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "DGO1",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :non_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_DGO1_nvar(; kwargs...) = 1
get_DGO1_nobj(; kwargs...) = 2
get_DGO1_ncon(; kwargs...) = 0 