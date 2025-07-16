DGO2_meta = Dict(
    :nvar => 1,
    :variable_nvar => false,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "DGO2",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:strictly_convex, :strictly_convex],
)

get_DGO2_nvar(; kwargs...) = 1
get_DGO2_nobj(; kwargs...) = 2
get_DGO2_ncon(; kwargs...) = 0 