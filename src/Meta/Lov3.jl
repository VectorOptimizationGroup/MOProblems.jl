Lov3_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "Lov3",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:strictly_convex, :non_convex],
)

get_Lov3_nvar(; kwargs...) = 2
