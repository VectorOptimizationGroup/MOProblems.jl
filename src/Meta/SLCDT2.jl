SLCDT2_meta = ProblemMeta(
    nvar = 10,
    variable_nvar = false,
    nobj = 3,
    name = "SLCDT2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)

