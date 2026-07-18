FA1_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "FA1",
    has_bounds = true,
    has_jacobian = true,  # Registered for x₁ > 0; see the FA documentation
    strict_convexity = [:not_strictly_convex, :not_strictly_convex, :not_strictly_convex],
)