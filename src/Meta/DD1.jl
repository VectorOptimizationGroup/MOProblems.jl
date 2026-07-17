DD1_meta = ProblemMeta(
    dimension = FixedDimension(5, 2),
    name = "DD1",
    has_jacobian = true,
    has_hessian = true,
    ncon_eq = 2,
    ncon_ineq = 1,
    has_constraint_jacobian = true,
    has_constraint_hessian = true,
    strict_convexity = [:strictly_convex, :not_strictly_convex],
)
