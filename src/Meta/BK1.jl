BK1_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "BK1",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
