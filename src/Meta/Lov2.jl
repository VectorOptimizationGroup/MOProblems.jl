Lov2_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "Lov2",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_Lov2_nvar(; kwargs...) = 2