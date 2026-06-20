LTDZ_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "LTDZ",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex, :non_convex], # Objective convexities
)
