JOS4_meta = ProblemMeta(
    dimension = FixedDimension(20, 2),
    name = "JOS4",               # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    strict_convexity = [:not_strictly_convex, :not_strictly_convex],
)
