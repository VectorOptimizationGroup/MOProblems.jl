AP4_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "AP4",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    strict_convexity = [:not_strictly_convex, :strictly_convex, :strictly_convex],
)
