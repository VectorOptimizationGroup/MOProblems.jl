Lov6_meta = ProblemMeta(
    nvar = 6,
    variable_nvar = false,
    nobj = 2,
    name = "Lov6",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_Lov6_nvar(; kwargs...) = 6
