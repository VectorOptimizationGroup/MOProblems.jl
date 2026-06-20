Lov2_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "Lov2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_Lov2_nvar(; kwargs...) = 2
