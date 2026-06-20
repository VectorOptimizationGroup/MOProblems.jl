SLCDT2_meta = ProblemMeta(
    dimension = FixedDimension(10, 3),
    name = "SLCDT2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)
