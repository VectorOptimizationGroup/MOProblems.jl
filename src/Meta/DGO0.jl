DGO0_meta = Dict(
    :nvar => 1,
    :variable_nvar => false,
    :nobj => 2,
    :minimize => true,
    :name => "DGO0",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:strictly_convex, :strictly_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_DGO0_nvar(; kwargs...) = 1
get_DGO0_nobj(; kwargs...) = 2
