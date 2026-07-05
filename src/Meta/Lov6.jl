Lov6_meta = ProblemMeta(
    dimension = FixedDimension(6, 2),
    name = "Lov6",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
