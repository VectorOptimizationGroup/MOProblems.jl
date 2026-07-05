AP3_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "AP3",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
