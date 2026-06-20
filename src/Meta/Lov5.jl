Lov5_meta = ProblemMeta(
    dimension = FixedDimension(3, 2),
    name = "Lov5",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)
