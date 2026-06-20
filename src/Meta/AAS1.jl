AAS1_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "AAS1",
    has_bounds = true,
    has_jacobian = false,
    convexity = [:convex, :convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_AAS1_nvar(; kwargs...) = 2
get_AAS1_nobj(; kwargs...) = 2
