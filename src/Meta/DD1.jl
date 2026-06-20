DD1_meta = ProblemMeta(
    dimension = FixedDimension(5, 2),
    name = "DD1",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :non_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
