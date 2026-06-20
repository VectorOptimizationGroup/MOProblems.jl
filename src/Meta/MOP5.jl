MOP5_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "MOP5",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)
