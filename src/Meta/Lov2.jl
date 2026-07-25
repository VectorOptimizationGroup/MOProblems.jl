Lov2_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "Lov2",
    has_bounds = false,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
