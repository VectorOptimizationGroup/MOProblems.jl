MMR2_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "MMR2",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:convex, :non_convex],
)

get_MMR2_nvar(; kwargs...) = 2
get_MMR2_nobj(; kwargs...) = 2
get_MMR2_ncon(; kwargs...) = 0

