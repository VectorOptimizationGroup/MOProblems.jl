PNR_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "PNR",               # Official problem name (Preuss–Naujoks–Rudolph)
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :strictly_convex], # f1 non-convex, f2 strictly convex
)
