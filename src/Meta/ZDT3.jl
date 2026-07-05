ZDT3_meta = ProblemMeta(
    dimension = VariableNvar(30, 2),
    name = "ZDT3",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
