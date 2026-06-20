MOP6_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "MOP6",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
)
