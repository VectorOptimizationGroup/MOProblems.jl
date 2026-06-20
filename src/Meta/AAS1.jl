AAS1_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "AAS1",
    has_bounds = true,
    has_jacobian = false,
    convexity = [:convex, :convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
