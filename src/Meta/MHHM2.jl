MHHM2_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "MHHM2",
    has_bounds = true,
    has_jacobian = true,
    strict_convexity = [:strictly_convex, :strictly_convex, :strictly_convex],
)
