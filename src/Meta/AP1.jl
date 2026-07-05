AP1_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "AP1",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    strict_convexity = [:not_strictly_convex, :strictly_convex, :strictly_convex],
)
