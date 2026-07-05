MLF2_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "MLF2",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
