AP1_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 3,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "AP1",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :convexity => [:non_convex, :strictly_convex, :strictly_convex],
)

get_AP1_nvar(; kwargs...) = 2
get_AP1_nobj(; kwargs...) = 3
get_AP1_ncon(; kwargs...) = 0 