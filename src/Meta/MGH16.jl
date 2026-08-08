MGH16_meta = ProblemMeta(
    dimension = VariableNobj(4, 5),
    name = "MGH16",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex, :not_strictly_convex, :not_strictly_convex, :not_strictly_convex],
)
