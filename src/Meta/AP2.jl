AP2_meta = ProblemMeta(
    nvar = 1,
    variable_nvar = false,
    nobj = 2,
    name = "AP2",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    convexity = [:strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

# Funções auxiliares lineares para número de variáveis e objetivos
get_AP2_nvar(; kwargs...) = 1
get_AP2_nobj(; kwargs...) = 2
