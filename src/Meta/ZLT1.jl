ZLT1_meta = ProblemMeta(
    nvar = 10,                    # Number of variables
    variable_nvar = false,        # Fixed number of variables
    nobj = 5,                     # Number of objectives
    name = "ZLT1",               # Official problem name
    has_bounds = true,            # Box constraints are defined
    has_jacobian = true,          # Analytical Jacobian available
    convexity = fill(:strictly_convex, 5), # Each objective is strictly convex
)
