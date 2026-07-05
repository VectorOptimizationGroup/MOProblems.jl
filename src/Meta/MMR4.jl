MMR4_meta = ProblemMeta(
    dimension = FixedDimension(3, 2),
    name = "MMR4",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
