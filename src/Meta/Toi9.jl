Toi9_meta = ProblemMeta(
    nvar = 4,
    variable_nvar = true,
    nobj = 4,
    variable_nobj = true,
    name = "Toi9",
    has_bounds = true,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex, :non_convex],
)

get_Toi9_nvar(; n::Integer = 4, kwargs...) = n
get_Toi9_nobj(; n::Integer = 4, m::Integer = n, kwargs...) = m
