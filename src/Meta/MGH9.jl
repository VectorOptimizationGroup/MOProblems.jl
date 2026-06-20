MGH9_meta = ProblemMeta(
    nvar = 3,                       # Number of variables
    variable_nvar = false,          # Fixed number of variables
    nobj = 15,                      # Number of objectives (residuals)
    name = "MGH9",                 # Official problem name
    has_bounds = true,              # Box constraints present
    has_jacobian = true,            # Analytical Jacobian available
    convexity = fill(:non_convex, 15), # Objective convexities
)

