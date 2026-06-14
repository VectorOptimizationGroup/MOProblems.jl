DTLZ1_meta = ProblemMeta(
    nvar = 7,
    variable_nvar = true,
    nobj = 3,
    minimize = true,
    name = "DTLZ1",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex, :non_convex],
)

get_DTLZ1_nvar(; k::Integer = 5, m::Integer = 3, kwargs...) = k + m - 1
get_DTLZ1_nobj(; m::Integer = 3, kwargs...) = m
