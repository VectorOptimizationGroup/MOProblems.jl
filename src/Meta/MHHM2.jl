MHHM2_meta = ProblemMeta(
    nvar = 2,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 3,                    # Number of objectives
    name = "MHHM2",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:convex, :convex, :convex], # Convexity of each objective
)
