ZDT4_meta = ProblemMeta(
    dimension = VariableNvar(10, 2),
    name = "ZDT4",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
