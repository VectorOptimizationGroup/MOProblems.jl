MHHM2_meta = ProblemMeta(
    dimension = FixedDimension(2, 3),
    name = "MHHM2",              # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:convex, :convex, :convex], # Convexity of each objective
)
