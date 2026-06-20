"""
    AbstractDimensionSpec

Abstract representation of how a benchmark problem determines its dimensions.
"""
abstract type AbstractDimensionSpec end

"""Fixed numbers of variables and objectives."""
struct FixedDimension <: AbstractDimensionSpec
    nvar::Int
    nobj::Int
    function FixedDimension(nvar::Integer, nobj::Integer)
        nvar >= 1 || throw(ArgumentError("nvar must be positive"))
        nobj >= 1 || throw(ArgumentError("nobj must be positive"))
        return new(Int(nvar), Int(nobj))
    end
end

"""A free `n` parameter determines `nvar`, while `nobj` is fixed."""
struct VariableNvar <: AbstractDimensionSpec
    default_n::Int
    nobj::Int
    function VariableNvar(default_n::Integer, nobj::Integer)
        default_n >= 1 || throw(ArgumentError("default n must be positive"))
        nobj >= 1 || throw(ArgumentError("nobj must be positive"))
        return new(Int(default_n), Int(nobj))
    end
end

"""Free `k` and `m` parameters determine `nvar = k + m - 1` and `nobj = m`."""
struct ParametricDimension <: AbstractDimensionSpec
    default_k::Int
    default_m::Int
    function ParametricDimension(default_k::Integer, default_m::Integer)
        default_k >= 1 || throw(ArgumentError("default k must be at least 1"))
        default_m >= 2 || throw(ArgumentError("default m must be at least 2"))
        return new(Int(default_k), Int(default_m))
    end
end

"""
    CoupledDimension(default_nvar, default_nobj)

Coupled dimensions specified by their default `nvar` and `nobj` values. Other
instances preserve the difference between those defaults.
"""
struct CoupledDimension <: AbstractDimensionSpec
    default_nvar::Int
    default_nobj::Int
    function CoupledDimension(default_nvar::Integer, default_nobj::Integer)
        default_nvar >= 1 || throw(ArgumentError("default nvar must be positive"))
        default_nobj >= 1 || throw(ArgumentError("default nobj must be positive"))
        return new(Int(default_nvar), Int(default_nobj))
    end
end

"""Return the number of variables in the specification's default instance."""
default_nvar(spec::FixedDimension) = spec.nvar
"""Return the number of objectives in the specification's default instance."""
default_nobj(spec::FixedDimension) = spec.nobj
default_nvar(spec::VariableNvar) = spec.default_n
default_nobj(spec::VariableNvar) = spec.nobj
default_nvar(spec::ParametricDimension) = spec.default_k + spec.default_m - 1
default_nobj(spec::ParametricDimension) = spec.default_m
default_nvar(spec::CoupledDimension) = spec.default_nvar
default_nobj(spec::CoupledDimension) = spec.default_nobj

"""Return the free dimensional parameters and their default values."""
dimension_parameters(::FixedDimension) = NamedTuple()
dimension_parameters(spec::VariableNvar) = (n = spec.default_n,)
dimension_parameters(spec::ParametricDimension) = (k = spec.default_k, m = spec.default_m)
dimension_parameters(spec::CoupledDimension) = (n = spec.default_nvar,)

"""Return an inspectable affine representation of `nvar` and `nobj`."""
dimension_relation(spec::FixedDimension) = (
    nvar = (constant = spec.nvar,),
    nobj = (constant = spec.nobj,),
)
dimension_relation(spec::VariableNvar) = (
    nvar = (n = 1, constant = 0),
    nobj = (constant = spec.nobj,),
)
dimension_relation(::ParametricDimension) = (
    nvar = (k = 1, m = 1, constant = -1),
    nobj = (k = 0, m = 1, constant = 0),
)
dimension_relation(spec::CoupledDimension) = (
    nvar = (n = 1, constant = 0),
    nobj = (n = 1, constant = spec.default_nobj - spec.default_nvar),
)

function _validated_convexity(dimension::FixedDimension, convexity)
    isnothing(convexity) && throw(ArgumentError("convexity is required for FixedDimension"))
    values = Symbol.(collect(convexity))
    length(values) == default_nobj(dimension) || throw(ArgumentError(
        "convexity length ($(length(values))) must match nobj ($(default_nobj(dimension)))",
    ))
    valid_values = (:strictly_convex, :convex, :non_convex)
    for value in values
        value in valid_values || throw(ArgumentError(
            "convexity values must be one of: $valid_values",
        ))
    end
    return values
end

function _validated_convexity(::AbstractDimensionSpec, convexity)
    isnothing(convexity) || throw(ArgumentError("convexity must be nothing for non-fixed dimensions"))
    return nothing
end

"""
    ProblemMeta

Typed metadata for a benchmark problem in the package catalog. Dimension data
is owned exclusively by `dimension`.
"""
struct ProblemMeta
    dimension::AbstractDimensionSpec
    name::String
    has_bounds::Bool
    has_jacobian::Bool
    has_hessian::Bool
    convexity::Union{Nothing, Vector{Symbol}}
    function ProblemMeta(;
        dimension::AbstractDimensionSpec,
        name::AbstractString,
        has_bounds::Bool = false,
        has_jacobian::Bool = false,
        has_hessian::Bool = false,
        convexity = nothing
    )
        convexity = _validated_convexity(dimension, convexity)

        return new(
            dimension,
            String(name),
            has_bounds,
            has_jacobian,
            has_hessian,
            convexity,
        )
    end
end

default_nvar(meta::ProblemMeta) = default_nvar(meta.dimension)
default_nobj(meta::ProblemMeta) = default_nobj(meta.dimension)
dimension_parameters(meta::ProblemMeta) = dimension_parameters(meta.dimension)
dimension_relation(meta::ProblemMeta) = dimension_relation(meta.dimension)

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
