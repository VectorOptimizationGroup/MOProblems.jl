MOP2_meta = ProblemMeta(
    dimension = VariableNvar(3, 2),
    name = "MOP2",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
