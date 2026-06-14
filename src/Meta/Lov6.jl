Lov6_meta = ProblemMeta(
    nvar = 6,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "Lov6",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_Lov6_nvar(; kwargs...) = 6