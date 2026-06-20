DTLZ3_meta = ProblemMeta(
    dimension = ParametricDimension(5, 3),
    name = "DTLZ3",              # Nome oficial do problema
    has_bounds = true,           # True se as variáveis têm restrições de caixa (limites inf/sup)
    has_jacobian = true,         # True se você fornece uma função jacobiana analítica
)
