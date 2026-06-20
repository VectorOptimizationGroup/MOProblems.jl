DGO2_meta = ProblemMeta(
    dimension = FixedDimension(1, 2),
    name = "DGO2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
