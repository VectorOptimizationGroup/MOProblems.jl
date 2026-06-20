MOP3_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "MOP3",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :convex],
)
