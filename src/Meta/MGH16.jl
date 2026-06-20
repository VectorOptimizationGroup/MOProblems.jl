MGH16_meta = ProblemMeta(
    dimension = FixedDimension(4, 5),
    name = "MGH16",
    has_bounds = true,
    has_jacobian = true,
    convexity = fill(:convex, 5),
)
