FF1_meta = Dict(
    :nvar => 2,                    # Number of variables
    :variable_nvar => false,       # Fixed number of variables
    :nobj => 2,                    # Number of objectives
    :ncon => 0,                    # Number of constraints
    :variable_ncon => false,       # Fixed number of constraints
    :minimize => true,             # Minimization problem
    :name => "FF1",               # Official problem name
    :has_equalities_only => false, # No equality constraints
    :has_inequalities_only => false, # No inequality constraints
    :has_bounds => true,           # Box constraints present
    :m_objtype => :nonlinear,      # Non-linear objectives
    :contype => :unconstrained,    # Unconstrained problem
    :origin => :academic,          # Academic benchmark
    :has_jacobian => true,         # Analytical Jacobian available
    :convexity => [:non_convex, :non_convex], # Convexity of each objective
) 