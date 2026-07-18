FDS_meta = ProblemMeta(
    dimension = VariableNvar(5, 3),
    name = "FDS",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:strictly_convex, :strictly_convex, :strictly_convex],
)
