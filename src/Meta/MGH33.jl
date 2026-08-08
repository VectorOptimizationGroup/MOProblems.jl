MGH33_meta = ProblemMeta(
    dimension = IndependentDimension(10, 10),
    name = "MGH33",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 10),
)
