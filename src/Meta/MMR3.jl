MMR3_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "MMR3",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:non_convex, :non_convex],
)

get_MMR3_nvar(; kwargs...) = 2
get_MMR3_nobj(; kwargs...) = 2

