DD1_meta = ProblemMeta(
    nvar = 5,
    variable_nvar = false,
    nobj = 2,
    name = "DD1",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_DD1_nvar(; kwargs...) = 5
get_DD1_nobj(; kwargs...) = 2
