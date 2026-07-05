SD_meta = ProblemMeta(
    dimension = FixedDimension(4, 2),
    name = "SD",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :strictly_convex],
)
