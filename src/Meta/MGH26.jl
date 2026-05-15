MGH26_meta = Dict(
    :nvar => 4,
    :variable_nvar => true,
    :nobj => 4,
    :variable_nobj => true,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "MGH26",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => fill(:non_convex, 4),
)

get_MGH26_nvar(; n::Integer = 4, kwargs...) = n
get_MGH26_nobj(; n::Integer = 4, m::Integer = n, kwargs...) = m
