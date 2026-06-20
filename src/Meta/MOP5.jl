MOP5_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 3,
    name = "MOP5",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)

