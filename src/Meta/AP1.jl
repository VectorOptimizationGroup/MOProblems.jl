AP1_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 3,
    minimize = true,
    name = "AP1",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    has_hessian = true,
    convexity = [:non_convex, :strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_AP1_nvar(; kwargs...) = 2
get_AP1_nobj(; kwargs...) = 3
