ZDT4_meta = ProblemMeta(
    nvar = 10,
    variable_nvar = true,
    nobj = 2,
    minimize = true,
    name = "ZDT4",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_ZDT4_nvar(; n::Integer = 10, kwargs...) = 1 * n + 0
get_ZDT4_nobj(; kwargs...) = 2
