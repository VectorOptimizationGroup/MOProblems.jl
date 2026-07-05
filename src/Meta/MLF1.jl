MLF1_meta = ProblemMeta(
    dimension = FixedDimension(1, 2),
    name = "MLF1",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
