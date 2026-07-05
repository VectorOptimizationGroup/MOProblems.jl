SLCDT2_meta = ProblemMeta(
    dimension = FixedDimension(10, 3),
    name = "SLCDT2",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex, :not_strictly_convex],
)
