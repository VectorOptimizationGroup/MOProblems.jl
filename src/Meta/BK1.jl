BK1_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "BK1",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :convexity => [:strictly_convex, :strictly_convex],
)

get_BK1_nvar(; kwargs...) = 2
get_BK1_nobj(; kwargs...) = 2
get_BK1_ncon(; kwargs...) = 0 