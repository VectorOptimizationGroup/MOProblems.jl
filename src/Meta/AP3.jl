AP3_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "AP3",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    has_hessian = true,
    convexity = [:non_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)

# Funções auxiliares lineares
get_AP3_nvar(; kwargs...) = 2
get_AP3_nobj(; kwargs...) = 2
