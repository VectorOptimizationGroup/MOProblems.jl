AP4_meta = Dict(
    :nvar => 3,
    :variable_nvar => false,
    :nobj => 3,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "AP4",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :has_hessian => true,
    :convexity => [:non_convex, :strictly_convex, :strictly_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_AP4_nvar(; kwargs...) = 3
get_AP4_nobj(; kwargs...) = 3
get_AP4_ncon(; kwargs...) = 0 
