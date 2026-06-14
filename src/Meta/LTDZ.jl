LTDZ_meta = ProblemMeta(
    nvar = 3,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 3,                    # Number of objectives
    minimize = true,             # Minimization problem
    name = "LTDZ",              # Official problem name
    has_bounds = true,           # Box constraints present
    m_objtype = :nonlinear,      # Non-linear objectives
    origin = :academic,          # Academic benchmark
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex, :non_convex], # Objective convexities
)

