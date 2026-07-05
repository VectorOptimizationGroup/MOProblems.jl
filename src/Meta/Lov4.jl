Lov4_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "Lov4",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :strictly_convex],
)
