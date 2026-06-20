DGO1_meta = ProblemMeta(
    dimension = FixedDimension(1, 2),
    name = "DGO1",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
