Toi8_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "Toi8",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = fill(:not_strictly_convex, 3),
)
