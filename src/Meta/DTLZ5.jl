DTLZ5_meta = ProblemMeta(
    dimension = ParametricDimension(10, 5),
    name = "DTLZ5",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 5),
)