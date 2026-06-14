ZDT6_meta = Dict(
    :nvar => 10,
    :variable_nvar => true,
    :nobj => 2,
    :minimize => true,
    :name => "ZDT6",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :non_convex],
    # :domain_critical => false,  # TODO: Implementar análise de criticidade do domínio
)

get_ZDT6_nvar(; n::Integer = 10, kwargs...) = 1 * n + 0
get_ZDT6_nobj(; kwargs...) = 2
