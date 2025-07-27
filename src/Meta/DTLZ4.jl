DTLZ4_meta = Dict(
    :nvar => 7,                    # Número de variáveis (k + m - 1 = 5 + 3 - 1 = 7)
    :variable_nvar => true,        # True se nvar pode ser alterado pelo usuário
    :nobj => 3,                    # Número de objetivos
    :ncon => 0,                    # Número de restrições
    :variable_ncon => false,       # True se ncon pode ser alterado
    :minimize => true,             # True para minimização, false para maximização
    :name => "DTLZ4",              # Nome oficial do problema
    :has_equalities_only => false, # True se todas as restrições são de igualdade
    :has_inequalities_only => false, # True se todas as restrições são de desigualdade (g(x) <= 0)
    :has_bounds => true,           # True se as variáveis têm restrições de caixa (limites inf/sup)
    :m_objtype => :nonlinear,      # Tipo de objetivo: [:linear, :nonlinear, :mixed, :other]
    :contype => :unconstrained,    # Tipo de restrição: [:unconstrained, :linear, :quadratic, :general]
    :origin => :academic,          # Origem: [:academic, :modelling, :real, :unknown]
    :has_jacobian => true,         # True se você fornece uma função jacobiana analítica
    :convexity => [:non_convex, :non_convex, :non_convex], # Convexidade de cada objetivo
)

# Funções auxiliares para problemas com número variável de dimensões
get_DTLZ4_nvar(; k::Integer = 5, m::Integer = 3, kwargs...) = k + m - 1
get_DTLZ4_nobj(; m::Integer = 3, kwargs...) = m
get_DTLZ4_ncon(; kwargs...) = 0 