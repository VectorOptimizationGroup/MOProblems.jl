FA1_meta = Dict(
    :nvar => 3,                    # Number of variables
    :variable_nvar => false,       # Can user change nvar?
    :nobj => 3,                    # Number of objectives
    :ncon => 0,                    # Number of constraints
    :variable_ncon => false,       # Can user change ncon?
    :minimize => true,             # Minimization problem?
    :name => "FA1",               # Official problem name
    :has_equalities_only => false, # All constraints are equalities?
    :has_inequalities_only => false, # All constraints are inequalities (g(x) <= 0)?
    :has_bounds => true,           # Variables have box constraints?
    :m_objtype => :nonlinear,      # [:linear, :nonlinear, :mixed, :other]
    :contype => :unconstrained,    # [:unconstrained, :linear, :quadratic, :general]
    :origin => :academic,          # [:academic, :modelling, :real, :unknown]
    :has_jacobian => true,         # Analytical jacobian provided?
    :convexity => [:non_convex, :non_convex, :non_convex], # Convexity of each objective
)
