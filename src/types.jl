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
        return new(Int(nvar), Int(nobj))
    end
end

"""A free `n` parameter determines `nvar`, while `nobj` is fixed."""
struct VariableNvar <: AbstractDimensionSpec
    default_n::Int
    nobj::Int
    function VariableNvar(default_n::Integer, nobj::Integer)
        return new(Int(default_n), Int(nobj))
    end
end

"""Free `k` and `m` parameters determine `nvar = k + m - 1` and `nobj = m`."""
struct ParametricDimension <: AbstractDimensionSpec
    default_k::Int
    default_m::Int
    function ParametricDimension(default_k::Integer, default_m::Integer)
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

"""
    ProblemMeta

Typed metadata for a benchmark problem in the package catalog. Dimension data
is owned exclusively by `dimension`. Constraint counts distinguish equalities
from inequalities, while derivative flags for objectives and constraints are
tracked independently.
"""
struct ProblemMeta
    dimension::AbstractDimensionSpec
    name::String
    has_bounds::Bool
    has_jacobian::Bool
    has_hessian::Bool
    ncon_eq::Int
    ncon_ineq::Int
    has_constraint_jacobian::Bool
    has_constraint_hessian::Bool
    strict_convexity::Union{Nothing, Vector{Symbol}}
    function ProblemMeta(;
        dimension::AbstractDimensionSpec,
        name::AbstractString,
        has_bounds::Bool = false,
        has_jacobian::Bool = false,
        has_hessian::Bool = false,
        ncon_eq::Integer = 0,
        ncon_ineq::Integer = 0,
        has_constraint_jacobian::Bool = false,
        has_constraint_hessian::Bool = false,
        strict_convexity::Union{Nothing, Vector{Symbol}} = nothing
    )
        return new(
            dimension,
            String(name),
            has_bounds,
            has_jacobian,
            has_hessian,
            Int(ncon_eq),
            Int(ncon_ineq),
            has_constraint_jacobian,
            has_constraint_hessian,
            strict_convexity,
        )
    end
end

default_nvar(meta::ProblemMeta) = default_nvar(meta.dimension)
default_nobj(meta::ProblemMeta) = default_nobj(meta.dimension)

"""
    MOProblem

Concrete evaluable instance of a benchmark problem.

Benchmark constructors such as `ZDT1()` and `AP1()` return `MOProblem`
instances. Static catalog information belongs to `ProblemMeta`; `MOProblem`
only stores the effective dimensions and the callables needed by the
evaluation API. General constraints follow `lcon <= c(x) <= ucon`; equalities
are the rows for which the corresponding lower and upper bounds are equal.
"""
struct MOProblem{F, J, H, B, C, CJ, CH, LC, UC}
    name::String
    nvar::Int
    nobj::Int
    f::F
    jacobian::J
    hessian::H
    bounds::B
    ncon::Int
    c::C
    constraint_jacobian::CJ
    constraint_hessian::CH
    lcon::LC
    ucon::UC
end

function MOProblem(
    nvar::Integer,
    nobj::Integer,
    f;
    name::AbstractString = "Unnamed MO Problem",
    bounds = nothing,
    jacobian = nothing,
    hessian = nothing,
    c = (),
    lcon = (),
    ucon = (),
    constraint_jacobian = nothing,
    constraint_hessian = nothing
)
    nvar = Int(nvar)
    nobj = Int(nobj)
    ncon = length(c)

    return MOProblem{
        typeof(f),
        typeof(jacobian),
        typeof(hessian),
        typeof(bounds),
        typeof(c),
        typeof(constraint_jacobian),
        typeof(constraint_hessian),
        typeof(lcon),
        typeof(ucon),
    }(
        String(name),
        nvar,
        nobj,
        f,
        jacobian,
        hessian,
        bounds,
        ncon,
        c,
        constraint_jacobian,
        constraint_hessian,
        lcon,
        ucon,
    )
end
