ZDT3_meta = ProblemMeta(
    nvar = 30,
    variable_nvar = true,
    nobj = 2,
    name = "ZDT3",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_ZDT3_nvar(; n::Integer = 30, kwargs...) = 1 * n + 0
get_ZDT3_nobj(; kwargs...) = 2
