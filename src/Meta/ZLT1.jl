ZLT1_meta = ProblemMeta(
    dimension = IndependentDimension(100, 2),
    name = "ZLT1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:strictly_convex, 2),
)
