MGH26_meta = ProblemMeta(
    dimension = CoupledDimension(4, 4),
    name = "MGH26",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 4),
)
