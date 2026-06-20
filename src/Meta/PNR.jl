PNR_meta = ProblemMeta(
    nvar = 2,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 2,                    # Number of objectives
    name = "PNR",               # Official problem name (Preuss–Naujoks–Rudolph)
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :strictly_convex], # f1 non-convex, f2 strictly convex
)

