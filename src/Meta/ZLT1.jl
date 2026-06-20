ZLT1_meta = ProblemMeta(
    dimension = FixedDimension(10, 5),
    name = "ZLT1",               # Official problem name
    has_bounds = true,            # Box constraints are defined
    has_jacobian = true,          # Analytical Jacobian available
    convexity = fill(:strictly_convex, 5), # Each objective is strictly convex
)
