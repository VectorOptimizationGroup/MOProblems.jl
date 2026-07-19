IKK1_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "IKK1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex, :not_strictly_convex],
)
