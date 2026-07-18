FA1_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "FA1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex, :not_strictly_convex],
)