DTLZ2_meta = ProblemMeta(
    dimension = ParametricDimension(10, 3),
    name = "DTLZ2",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 3),
)