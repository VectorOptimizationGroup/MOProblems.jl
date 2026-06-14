DGO1_meta = ProblemMeta(
    nvar = 1,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "DGO1",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

get_DGO1_nvar(; kwargs...) = 1
get_DGO1_nobj(; kwargs...) = 2
