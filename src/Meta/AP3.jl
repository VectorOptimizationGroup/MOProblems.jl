AP3_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "AP3",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    convexity = [:non_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
