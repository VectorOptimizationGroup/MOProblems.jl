MGH9_meta = Dict(
    :nvar => 3,                       # Number of variables
    :variable_nvar => false,          # Fixed number of variables
    :nobj => 15,                      # Number of objectives (residuals)
    :minimize => true,                # Minimization problem
    :name => "MGH9",                 # Official problem name
    :has_bounds => true,              # Box constraints present
    :m_objtype => :nonlinear,         # Non-linear objectives
    :origin => :academic,             # Academic benchmark
    :has_jacobian => true,            # Analytical Jacobian available
    :convexity => fill(:non_convex, 15), # Objective convexities
)

