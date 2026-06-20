MMR2_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "MMR2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
)

get_MMR2_nvar(; kwargs...) = 2
get_MMR2_nobj(; kwargs...) = 2

