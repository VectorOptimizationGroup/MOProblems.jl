ZDT5_meta = Dict(
    :nvar => 11,
    :variable_nvar => true,
    :nobj => 2,
    :ncon => 0,
    :variable_ncon => false,
    :minimize => true,
    :name => "ZDT5",
    :has_equalities_only => false,
    :has_inequalities_only => false,
    :has_bounds => true,
    :m_objtype => :other,
    :contype => :unconstrained,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:unknown, :unknown],
)

get_ZDT5_nvar(; m::Integer = 11, kwargs...) = 1 * m + 0
get_ZDT5_nobj(; kwargs...) = 2
get_ZDT5_ncon(; kwargs...) = 0 