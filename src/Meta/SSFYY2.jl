SSFYY2_meta = ProblemMeta(
    nvar = 1,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "SSFYY2",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :strictly_convex],
)

