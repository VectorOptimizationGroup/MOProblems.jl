ZDT6_meta = ProblemMeta(
    dimension = VariableNvar(10, 2),
    name = "ZDT6",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
