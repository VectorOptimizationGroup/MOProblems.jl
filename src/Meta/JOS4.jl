JOS4_meta = ProblemMeta(
    dimension = VariableNvar(50, 2),
    name = "JOS4",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
