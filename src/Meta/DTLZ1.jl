DTLZ1_meta = Dict(
    :nvar => 7,
    :variable_nvar => true,
    :nobj => 3,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "DTLZ1",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :non_convex, :non_convex],
)

get_DTLZ1_nvar(; k::Integer = 5, m::Integer = 3, kwargs...) = k + m - 1
get_DTLZ1_nobj(; m::Integer = 3, kwargs...) = m
get_DTLZ1_ncon(; kwargs...) = 0 