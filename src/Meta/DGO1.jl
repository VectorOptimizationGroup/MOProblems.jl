DGO1_meta = ProblemMeta(
    dimension = FixedDimension(1, 2),
    name = "DGO1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
