Toi9_meta = Dict(
    :nvar => 4,
    :variable_nvar => true,
    :nobj => 4,
    :variable_nobj => true,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "Toi9",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :non_convex, :non_convex, :non_convex],
)

get_Toi9_nvar(; n::Integer = 4, kwargs...) = n
get_Toi9_nobj(; n::Integer = 4, m::Integer = n, kwargs...) = m
