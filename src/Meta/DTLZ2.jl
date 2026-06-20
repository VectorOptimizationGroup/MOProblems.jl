DTLZ2_meta = ProblemMeta(
    nvar = 7,
    variable_nvar = true,
    nobj = 3,
    name = "DTLZ2",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)

get_DTLZ2_nvar(; k::Integer = 5, m::Integer = 3, kwargs...) = k + m - 1
get_DTLZ2_nobj(; m::Integer = 3, kwargs...) = m
