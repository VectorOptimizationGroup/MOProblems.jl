Lov5_meta = ProblemMeta(
    dimension = FixedDimension(3, 2),
    name = "Lov5",
    has_bounds = false,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
