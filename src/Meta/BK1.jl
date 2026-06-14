BK1_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 2,
    :minimize => true,
    :name => "BK1",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:strictly_convex, :strictly_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_BK1_nvar(; kwargs...) = 2
get_BK1_nobj(; kwargs...) = 2
