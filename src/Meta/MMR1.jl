MMR1_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    name = "MMR1",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
)

get_MMR1_nvar(; kwargs...) = 2
get_MMR1_nobj(; kwargs...) = 2

