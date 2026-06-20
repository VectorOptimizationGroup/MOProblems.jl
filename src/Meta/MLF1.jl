MLF1_meta = ProblemMeta(
    dimension = FixedDimension(1, 2),
    name = "MLF1",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex], # Convexity of each objective
)
