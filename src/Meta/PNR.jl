PNR_meta = ProblemMeta(
    dimension = FixedDimension(2, 2),
    name = "PNR",               # Official problem name (Preuss–Naujoks–Rudolph)
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    strict_convexity = [:not_strictly_convex, :strictly_convex],
)
