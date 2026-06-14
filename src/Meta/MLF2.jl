MLF2_meta = ProblemMeta(
    nvar = 2,                    # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 2,                    # Number of objectives
    minimize = true,             # Minimization problem
    name = "MLF2",              # Official problem name
    has_bounds = true,           # Box constraints present
    m_objtype = :nonlinear,      # Non-linear objectives
    origin = :academic,          # Academic benchmark
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex], # Convexity of each objective
)

