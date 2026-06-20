JOS4_meta = ProblemMeta(
    nvar = 20,                   # Number of variables
    variable_nvar = false,       # Fixed number of variables
    nobj = 2,                    # Number of objectives
    name = "JOS4",               # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex], # Convexity of each objective
)

# Funções auxiliares para problemas com número variável de dimensões
get_JOS4_nvar(; n::Integer = 20, kwargs...) = 1 * n + 0
get_JOS4_nobj(; kwargs...) = 2
