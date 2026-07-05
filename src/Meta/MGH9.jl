MGH9_meta = ProblemMeta(
    dimension = FixedDimension(3, 15),
    name = "MGH9",                 # Official problem name
    has_bounds = true,              # Box constraints present
    has_jacobian = true,            # Analytical Jacobian available
    strict_convexity = fill(:not_strictly_convex, 15),
)
