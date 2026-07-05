VU1_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "VU1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :strictly_convex],
)
