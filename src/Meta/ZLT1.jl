ZLT1_meta = Dict(
    :nvar => 10,                    # Number of variables
    :variable_nvar => false,        # Fixed number of variables
    :nobj => 5,                     # Number of objectives
    :ncon => 0,                     # No additional constraints
    :variable_ncon => false,        # Fixed number of constraints
    :minimize => true,              # Minimization problem
    :name => "ZLT1",               # Official problem name
    :has_equalities_only => false,  # No equality constraints
    :has_inequalities_only => false,# No inequality constraints
    :has_bounds => true,            # Box constraints are defined
    :m_objtype => :nonlinear,       # Nonlinear objective functions
    :contype => :unconstrained,     # No explicit constraints
    :origin => :academic,           # Academic benchmark
    :has_jacobian => true,          # Analytical Jacobian available
    :convexity => fill(:strictly_convex, 5), # Each objective is strictly convex
)
