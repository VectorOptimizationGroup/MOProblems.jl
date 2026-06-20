MMR4_meta = ProblemMeta(
    dimension = FixedDimension(3, 2),
    name = "MMR4",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :convex],
)
