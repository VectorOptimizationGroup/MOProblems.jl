FA1_meta = ProblemMeta(
    dimension = FixedDimension(3, 3),
    name = "FA1",               # Official problem name
    has_bounds = true,           # Variables have box constraints?
    has_jacobian = true,         # Analytical jacobian provided?
    convexity = [:non_convex, :non_convex, :non_convex], # Convexity of each objective
)
