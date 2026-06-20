AAS2_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "AAS2",
    has_bounds = true,
    has_jacobian = false,
    convexity = [:convex, :convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_AAS2_nvar(; kwargs...) = 2
get_AAS2_nobj(; kwargs...) = 2
