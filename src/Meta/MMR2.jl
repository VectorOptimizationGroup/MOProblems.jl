MMR2_meta = ProblemMeta(
    nvar = 2,
    variable_nvar = false,
    nobj = 2,
    minimize = true,
    name = "MMR2",
    has_bounds = true,
    m_objtype = :nonlinear,
    origin = :academic,
    has_jacobian = true,
    convexity = [:convex, :non_convex],
)

get_MMR2_nvar(; kwargs...) = 2
get_MMR2_nobj(; kwargs...) = 2

