Lov3_meta = Dict(
    :nvar => 2,
    :variable_nvar => false,
    :nobj => 2,
    :minimize => true,
    :name => "Lov3",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:strictly_convex, :non_convex],
)

get_Lov3_nvar(; kwargs...) = 2