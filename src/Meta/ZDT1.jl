ZDT1_meta = Dict(
    :nvar => 30,
    :variable_nvar => true,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "ZDT1",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:convex, :non_convex],
)

get_ZDT1_nvar(; n::Integer = 30, kwargs...) = 1 * n + 0
get_ZDT1_nobj(; kwargs...) = 2
get_ZDT1_ncon(; kwargs...) = 0 