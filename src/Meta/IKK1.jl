IKK1_meta = ProblemMeta(
    nvar = 2,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 3,                    # Number of objectives
    name = "IKK1",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex, :non_convex], # Convexity of each objective
) 
