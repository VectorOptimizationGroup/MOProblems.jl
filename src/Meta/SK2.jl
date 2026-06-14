SK2_meta = ProblemMeta(
    nvar = 4,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "SK2",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:strictly_convex, :non_convex],
)

