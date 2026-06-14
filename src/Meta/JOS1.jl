JOS1_meta = ProblemMeta(
    nvar = 2,                    # Number of variables
    variable_nvar = true,       # Fixed number of variables
    nobj = 2,                    # Number of objectives
    minimize = true,             # Minimization problem
    name = "JOS1",               # Official problem name
    has_bounds = true,           # Box constraints present
    m_objtype = :nonlinear,      # Non-linear objectives
    origin = :academic,          # Academic benchmark
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:strictly_convex, :strictly_convex], # Convexity of each objective
)

# Funções auxiliares para problemas com número variável de dimensões
get_JOS1_nvar(; n::Integer = 2, kwargs...) = 1 * n + 0
get_JOS1_nobj(; kwargs...) = 2
