MGH9_meta = Dict(
    :nvar => 3,                       # Number of variables
    :variable_nvar => false,          # Fixed number of variables
    :nobj => 15,                      # Number of objectives (residuals)
    :ncon => 0,                       # Number of constraints
    :variable_ncon => false,          # Fixed number of constraints
    :minimize => true,                # Minimization problem
    :name => "MGH9",                 # Official problem name
    :has_equalities_only => false,    # No equality constraints
    :has_inequalities_only => false,  # No inequality constraints
    :has_bounds => true,              # Box constraints present
    :m_objtype => :nonlinear,         # Non-linear objectives
    :contype => :unconstrained,       # Unconstrained (box limits only)
    :origin => :academic,             # Academic benchmark
    :has_jacobian => true,            # Analytical Jacobian available
    :convexity => fill(:non_convex, 15), # Objective convexities
)

