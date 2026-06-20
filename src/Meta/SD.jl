SD_meta = ProblemMeta(
    nvar = 4,
    variable_nvar = false,
    nobj = 2,
    name = "SD",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :strictly_convex],
)

