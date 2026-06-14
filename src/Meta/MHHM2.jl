MHHM2_meta = Dict(
    :nvar => 2,                    # Number of variables
    :variable_nvar => false,       # Fixed number of variables
    :nobj => 3,                    # Number of objectives
    :minimize => true,             # Minimization problem
    :name => "MHHM2",              # Official problem name
    :has_bounds => true,           # Box constraints present
    :m_objtype => :nonlinear,      # Non-linear objectives
    :origin => :academic,          # Academic benchmark
    :has_jacobian => true,         # Analytical Jacobian available
    :convexity => [:convex, :convex, :convex], # Convexity of each objective
)