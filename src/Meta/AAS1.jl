AAS1_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 2,
    :minimize => true,
    :name => "AAS1",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => false,
    :convexity => [:convex, :convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_AAS1_nvar(; kwargs...) = 2
get_AAS1_nobj(; kwargs...) = 2
