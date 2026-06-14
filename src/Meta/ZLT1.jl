ZLT1_meta = Dict(
    :nvar => 10,                    # Number of variables
    :variable_nvar => false,        # Fixed number of variables
    :nobj => 5,                     # Number of objectives
    :minimize => true,              # Minimization problem
    :name => "ZLT1",               # Official problem name
    :has_bounds => true,            # Box constraints are defined
    :m_objtype => :nonlinear,       # Nonlinear objective functions
    :origin => :academic,           # Academic benchmark
    :has_jacobian => true,          # Analytical Jacobian available
    :convexity => fill(:strictly_convex, 5), # Each objective is strictly convex
)
