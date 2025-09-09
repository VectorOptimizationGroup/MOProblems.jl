MMR4_meta = Dict(
    :nvar => 3,
    :variable_nvar => false,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "MMR4",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :convex],
)

get_MMR4_nvar(; kwargs...) = 3
get_MMR4_nobj(; kwargs...) = 2
get_MMR4_ncon(; kwargs...) = 0

