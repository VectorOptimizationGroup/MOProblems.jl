JOS1_meta = ProblemMeta(
    dimension = VariableNvar(2, 2),
    name = "JOS1",               # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    strict_convexity = [:strictly_convex, :strictly_convex],
)
