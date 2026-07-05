DTLZ1_meta = ProblemMeta(
    dimension = ParametricDimension(5, 3),
    name = "DTLZ1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 3),
)
