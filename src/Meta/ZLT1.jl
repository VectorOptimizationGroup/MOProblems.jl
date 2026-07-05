ZLT1_meta = ProblemMeta(
    dimension = FixedDimension(10, 5),
    name = "ZLT1",               # Official problem name
    has_bounds = true,            # Box constraints are defined
    has_jacobian = true,          # Analytical Jacobian available
    strict_convexity = [:strictly_convex, :strictly_convex, :strictly_convex, :strictly_convex, :strictly_convex],
)
