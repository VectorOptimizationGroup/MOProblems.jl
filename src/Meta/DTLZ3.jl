DTLZ3_meta = ProblemMeta(
    nvar = 7,                    # Número de variáveis (k + m - 1 = 5 + 3 - 1 = 7)
    variable_nvar = true,        # True se nvar pode ser alterado pelo usuário
    nobj = 3,                    # Número de objetivos
    name = "DTLZ3",              # Nome oficial do problema
    has_bounds = true,           # True se as variáveis têm restrições de caixa (limites inf/sup)
    has_jacobian = true,         # True se você fornece uma função jacobiana analítica
    convexity = [:non_convex, :non_convex, :non_convex], # Convexidade de cada objetivo
)

# Funções auxiliares para problemas com número variável de dimensões
get_DTLZ3_nvar(; k::Integer = 5, m::Integer = 3, kwargs...) = k + m - 1
get_DTLZ3_nobj(; m::Integer = 3, kwargs...) = m
