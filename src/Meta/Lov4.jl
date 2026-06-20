Lov4_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "Lov4",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :strictly_convex],
)

get_Lov4_nvar(; kwargs...) = 2
