MMR1_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "MMR1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
