FDS_meta = Dict(
    :nvar => 5,                    # Number of variables
    :variable_nvar => true,       # True se nvar pode ser alterado pelo usuário
    :nobj => 3,                    # Number of objectives
    :minimize => true,             # Minimization problem
    :name => "FDS",               # Official problem name
    :has_bounds => true,           # Box constraints present
    :m_objtype => :nonlinear,      # Non-linear objectives
    :origin => :academic,          # Academic benchmark
    :has_jacobian => true,         # Analytical Jacobian available
    :convexity => [:strictly_convex, :strictly_convex, :strictly_convex], # Convexity of each objective
)

# Funções auxiliares para problemas com número variável de dimensões
get_FDS_nvar(; n::Integer = 5, kwargs...) = 1 * n + 0
get_FDS_nobj(; kwargs...) = 3
