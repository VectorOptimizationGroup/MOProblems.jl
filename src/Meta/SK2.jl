SK2_meta = ProblemMeta(
    dimension = FixedDimension(4, 2),
    name = "SK2",
    has_bounds = false,   # No explicit variable bounds in the sources
    has_jacobian = true,
    strict_convexity = [:strictly_convex, :not_strictly_convex],
)
