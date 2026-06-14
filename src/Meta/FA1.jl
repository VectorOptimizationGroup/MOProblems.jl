FA1_meta = Dict(
    :nvar => 3,                    # Number of variables
    :variable_nvar => false,       # Can user change nvar?
    :nobj => 3,                    # Number of objectives
    :minimize => true,             # Minimization problem?
    :name => "FA1",               # Official problem name
    :has_bounds => true,           # Variables have box constraints?
    :m_objtype => :nonlinear,      # [:linear, :nonlinear, :mixed, :other]
    :origin => :academic,          # [:academic, :modelling, :real, :unknown]
    :has_jacobian => true,         # Analytical jacobian provided?
    :convexity => [:non_convex, :non_convex, :non_convex], # Convexity of each objective
)
