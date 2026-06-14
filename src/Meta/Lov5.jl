Lov5_meta = Dict(
    :nvar => 3,
    :variable_nvar => false,
    :nobj => 2,
    :minimize => true,
    :name => "Lov5",
    :has_bounds => true,
    :m_objtype => :nonlinear,
    :origin => :academic,
    :has_jacobian => true,
    :convexity => [:non_convex, :non_convex],
)

get_Lov5_nvar(; kwargs...) = 3