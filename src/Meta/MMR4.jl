MMR4_meta = ProblemMeta(
    nvar = 3,
    variable_nvar = false,
    nobj = 2,
    name = "MMR4",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :convex],
)

get_MMR4_nvar(; kwargs...) = 3
get_MMR4_nobj(; kwargs...) = 2

