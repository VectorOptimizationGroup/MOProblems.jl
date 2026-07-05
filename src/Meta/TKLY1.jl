TKLY1_meta = ProblemMeta(
    dimension = FixedDimension(4, 2),
    name = "TKLY1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
