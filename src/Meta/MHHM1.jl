MHHM1_meta = ProblemMeta(
    nvar = 1,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 3,                    # Number of objectives
    name = "MHHM1",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:convex, :convex, :convex], # Convexity of each objective
)
