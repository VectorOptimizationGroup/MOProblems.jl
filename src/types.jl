"""
    ProblemMeta

Typed metadata for a benchmark problem in the package catalog.

`ProblemMeta` is the catalog representation used by `META`. It keeps metadata
validation centralized and makes the static benchmark schema explicit.
"""
struct ProblemMeta
    nvar::Int
    variable_nvar::Bool
    nobj::Int
    variable_nobj::Bool
    minimize::Bool
    name::String
    has_bounds::Bool
    m_objtype::Symbol
    origin::Symbol
    has_jacobian::Bool
    has_hessian::Bool
    convexity::Vector{Symbol}
    function ProblemMeta(;
        nvar::Integer,
        variable_nvar::Bool = false,
        nobj::Integer,
        variable_nobj::Bool = false,
        minimize::Bool = true,
        name::AbstractString,
        has_bounds::Bool = false,
        m_objtype::Symbol = :nonlinear,
        origin::Symbol = :unknown,
        has_jacobian::Bool = false,
        has_hessian::Bool = false,
        convexity
    )
        nvar = Int(nvar)
        nobj = Int(nobj)
        convexity = Symbol.(collect(convexity))

        @assert nvar >= 1 "nvar must be positive"
        @assert nobj >= 1 "nobj must be positive"
        @assert m_objtype in (:linear, :nonlinear, :mixed, :other) "m_objtype must be one of: :linear, :nonlinear, :mixed, :other"
        @assert origin in (:academic, :modelling, :real, :unknown) "origin must be one of: :academic, :modelling, :real, :unknown"
        @assert length(convexity) == nobj "convexity length ($(length(convexity))) must match nobj ($nobj)"

        valid_convexity = (:strictly_convex, :convex, :non_convex, :unknown)
        for value in convexity
            @assert value in valid_convexity "convexity values must be one of: $valid_convexity"
        end

        return new(
            nvar,
            variable_nvar,
            nobj,
            variable_nobj,
            minimize,
            String(name),
            has_bounds,
            m_objtype,
            origin,
            has_jacobian,
            has_hessian,
            convexity,
        )
    end
end

"""
    MOProblem

Concrete evaluable instance of a benchmark problem.

Benchmark constructors such as `ZDT1()` and `AP1()` return `MOProblem`
instances. Static catalog information belongs to `ProblemMeta`; `MOProblem`
only stores the effective dimensions and the callables needed by the
evaluation API.
"""
struct MOProblem{F, J, H, B}
    name::String
    nvar::Int
    nobj::Int
    f::F
    jacobian::J
    hessian::H
    bounds::B
end

function _check_bounds(bounds, nvar::Int)
    isnothing(bounds) && return nothing
    @assert bounds isa Tuple && length(bounds) == 2 "bounds must be a tuple (lower, upper)"
    @assert length(bounds[1]) == nvar "Lower bounds length ($(length(bounds[1]))) must match nvar ($nvar)"
    @assert length(bounds[2]) == nvar "Upper bounds length ($(length(bounds[2]))) must match nvar ($nvar)"
    return nothing
end

function _typed_bounds(::Type{T}, bounds, nvar::Int) where {T <: AbstractFloat}
    isnothing(bounds) && return nothing
    _check_bounds(bounds, nvar)
    return (T.(bounds[1]), T.(bounds[2]))
end

function _check_derivative(derivative, nobj::Int, name::String)
    isnothing(derivative) && return nothing
    derivative isa Function && return nothing
    if derivative isa AbstractVector
        @assert length(derivative) == nobj "$name row-function count ($(length(derivative))) must match nobj ($nobj)"
        @assert all(d -> d isa Function, derivative) "$name row entries must be functions"
        return nothing
    end
    error("$name must be either nothing, a function, or a vector of row functions")
end

function MOProblem(
    nvar::Integer,
    nobj::Integer,
    f;
    name::AbstractString = "Unnamed MO Problem",
    bounds = nothing,
    jacobian = nothing,
    hessian = nothing
)
    nvar = Int(nvar)
    nobj = Int(nobj)

    @assert nvar >= 1 "nvar must be positive"
    @assert nobj >= 1 "nobj must be positive"
    @assert length(f) == nobj "Objective function count ($(length(f))) must match nobj ($nobj)"
    _check_bounds(bounds, nvar)
    _check_derivative(jacobian, nobj, "jacobian")
    _check_derivative(hessian, nobj, "hessian")

    return MOProblem{typeof(f), typeof(jacobian), typeof(hessian), typeof(bounds)}(
        String(name),
        nvar,
        nobj,
        f,
        jacobian,
        hessian,
        bounds,
    )
end

function MOProblem(
    ::Type{T},
    nvar::Integer,
    nobj::Integer,
    f;
    name::AbstractString = "Unnamed MO Problem",
    bounds = nothing,
    jacobian = nothing,
    hessian = nothing
) where {T <: AbstractFloat}
    return MOProblem(
        nvar,
        nobj,
        f;
        name = name,
        bounds = _typed_bounds(T, bounds, Int(nvar)),
        jacobian = jacobian,
        hessian = hessian,
    )
end

function MOProblem{T}(
    nvar::Integer,
    nobj::Integer,
    f;
    name::AbstractString = "Unnamed MO Problem",
    bounds = nothing,
    jacobian = nothing,
    hessian = nothing
) where {T <: AbstractFloat}
    return MOProblem(T, nvar, nobj, f; name = name, bounds = bounds, jacobian = jacobian, hessian = hessian)
end
