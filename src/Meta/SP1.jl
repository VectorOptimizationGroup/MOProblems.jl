SP1_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "SP1",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:strictly_convex, :strictly_convex],
)

