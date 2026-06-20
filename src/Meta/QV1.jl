QV1_meta = ProblemMeta(
    nvar = 16,                   # Number of variables
    variable_nvar = true,        # Allows changing the number of variables via constructor
    nobj = 2,                    # Number of objectives
    name = "QV1",              # Problem name (Quagliarella–Vicini)
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
    convexity = [:non_convex, :non_convex], # Both objectives non-convex
)

get_QV1_nvar(; n::Integer = 16, kwargs...) = 1 * n + 0
get_QV1_nobj(; kwargs...) = 2
