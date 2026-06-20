Lov5_meta = ProblemMeta(
    nvar = 3,
    variable_nvar = false,
    nobj = 2,
    name = "Lov5",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_Lov5_nvar(; kwargs...) = 3
