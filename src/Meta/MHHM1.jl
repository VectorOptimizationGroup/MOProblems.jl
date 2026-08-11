MHHM1_meta = ProblemMeta(
    dimension = FixedDimension(1, 3),
    name = "MHHM1",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:strictly_convex, :strictly_convex, :strictly_convex],
)
