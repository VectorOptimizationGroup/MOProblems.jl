SD_meta = ProblemMeta(
    dimension = FixedDimension(4, 2),
    name = "SD",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :strictly_convex],
)
