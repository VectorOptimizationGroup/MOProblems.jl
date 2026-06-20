DGO2_meta = ProblemMeta(
    nvar = 1,
    variable_nvar = false,
    nobj = 2,
    name = "DGO2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_DGO2_nvar(; kwargs...) = 1
get_DGO2_nobj(; kwargs...) = 2
