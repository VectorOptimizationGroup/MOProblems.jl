JOS4_meta = Dict(
    :nvar => 20,                   # Number of variables
    :variable_nvar => false,       # Fixed number of variables
    :nobj => 2,                    # Number of objectives
    :ncon => 0,                    # Number of constraints
    :variable_ncon => false,       # Fixed number of constraints
    :minimize => true,             # Minimization problem
    :name => "JOS4",               # Official problem name
    :has_equalities_only => false, # No equality constraints
    :has_inequalities_only => false, # No inequality constraints
    :has_bounds => true,           # Box constraints present
    :m_objtype => :nonlinear,      # Non-linear objectives
    :contype => :unconstrained,    # Unconstrained problem
    :origin => :academic,          # Academic benchmark
    :has_jacobian => true,         # Analytical Jacobian available
    :convexity => [:non_convex, :non_convex], # Convexity of each objective
)

# Funções auxiliares para problemas com número variável de dimensões
get_JOS4_nvar(; n::Integer = 20, kwargs...) = 1 * n + 0
get_JOS4_nobj(; kwargs...) = 2
get_JOS4_ncon(; kwargs...) = 0 