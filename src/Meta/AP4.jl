AP4_meta = Dict(
    :nvar => 3,
    :variable_nvar => false,
    :nobj => 3,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "AP4",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :convexity => [:non_convex, :strictly_convex, :strictly_convex],
)

get_AP4_nvar(; kwargs...) = 3
get_AP4_nobj(; kwargs...) = 3
get_AP4_ncon(; kwargs...) = 0 