AP1_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "AP1",
    has_bounds = true,
    has_jacobian = true,
    has_hessian = true,
    convexity = [:non_convex, :strictly_convex, :strictly_convex],
    # domain_critical = false,  # TODO: Implementar análise de criticidade do domínio
)
