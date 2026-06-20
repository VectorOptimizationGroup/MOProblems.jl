MMR2_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "MMR2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
)
