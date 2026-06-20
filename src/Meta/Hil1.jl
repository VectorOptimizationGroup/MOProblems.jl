Hil1_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "Hil1",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex], # Convexity of each objective
) 
