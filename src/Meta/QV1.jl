QV1_meta = Dict(
    :nvar => 16,                   # Number of variables
    :variable_nvar => true,        # Allows changing the number of variables via constructor
    :nobj => 2,                    # Number of objectives
    :ncon => 0,                    # Number of constraints
    :variable_ncon => false,       # Fixed number of constraints
    :minimize => true,             # Minimization problem
    :name => "QV1",              # Problem name (Quagliarella–Vicini)
    :has_equalities_only => false, # No equality constraints
    :has_inequalities_only => false, # No inequality constraints
    :has_bounds => true,           # Box constraints present
    :m_objtype => :nonlinear,      # Non-linear objectives
    :contype => :unconstrained,    # Unconstrained problem
    :origin => :academic,          # Academic benchmark
    :has_jacobian => true,         # Analytical Jacobian available
    :convexity => [:non_convex, :non_convex], # Both objectives non-convex
)

get_QV1_nvar(; n::Integer = 16, kwargs...) = 1 * n + 0
get_QV1_nobj(; kwargs...) = 2
get_QV1_ncon(; kwargs...) = 0 
