MGH33_meta = ProblemMeta(
    nvar = 10,
    variable_nvar = false,
    nobj = 10,
    minimize = true,
    name = "MGH33",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = fill(:convex, 10),
)

