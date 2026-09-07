"""
    get_problem_names() -> Vector{String}

Return the names of all problems registered in the catalog.

Read static metadata without constructing problem instances. The returned
vector is newly allocated, and its order is unspecified.

# Examples
```julia
using MOProblems

names = get_problem_names()
sort!(names)
```

See also [`filter_problems`](@ref).
"""
function get_problem_names()
    return collect(keys(META))
end

"""
    filter_problems(; <keyword arguments>) -> Vector{String}

Return the names of catalog problems satisfying all supplied criteria.

Read static metadata without constructing or evaluating problem instances.
The returned vector is newly allocated and sorted lexicographically. With no
criteria, return all catalog names; with no matches, return an empty vector.

For filters accepting `nothing`, this value disables the criterion. Boolean
filters set to `false` require the corresponding property to be false. All
numeric limits are inclusive; an interval with its minimum above its maximum
has no matches.

# Keyword arguments
- `name_pattern::Union{Nothing, AbstractString, Regex} = nothing`: match names
  using `occursin`. Strings specify literal, case-sensitive substrings;
  regular expressions follow their own flags. Use anchors for a full-name
  regular-expression match.
- `min_vars::Int = 0`, `max_vars::Int = typemax(Int)`: limits on the number of
  variables in the default instance.
- `min_objs::Int = 0`, `max_objs::Int = typemax(Int)`: limits on the number of
  objectives in the default instance. Dimension limits do not search other
  configurations supported by the constructors.
- `dimension_type::Union{Nothing, Type{<:AbstractDimensionSpec}} = nothing`:
  require `meta.dimension isa dimension_type`.
- `has_bounds::Union{Nothing, Bool} = nothing`: whether variable bounds are
  registered.
- `has_jacobian::Union{Nothing, Bool} = nothing`: whether an analytical
  objective Jacobian evaluator is registered.
- `has_hessian::Union{Nothing, Bool} = nothing`: whether an analytical
  objective Hessian evaluator is registered.
- `min_con_eq::Int = 0`, `max_con_eq::Int = typemax(Int)`: limits on the number
  of general equality constraints, excluding variable bounds.
- `min_con_ineq::Int = 0`, `max_con_ineq::Int = typemax(Int)`: limits on the
  number of general inequality constraints, excluding variable bounds.
- `has_constraint_jacobian::Union{Nothing, Bool} = nothing`: whether analytical
  first derivatives of the constraints are registered.
- `has_constraint_hessian::Union{Nothing, Bool} = nothing`: whether analytical
  second derivatives of the constraints are registered.
- `any_strictly_convex::Union{Nothing, Bool} = nothing`: whether at least one
  objective is marked strictly convex. With `false`, require none to be marked
  strictly convex.
- `all_strictly_convex::Union{Nothing, Bool} = nothing`: whether all objectives
  are marked strictly convex. With `false`, require at least one to be marked
  not strictly convex.

Derivative registration does not guarantee differentiability at every point
of a problem's domain. Consult the family documentation for restrictions.

Problems with unavailable strict-convexity metadata are excluded whenever
either strict-convexity filter is requested, including with `false`. An
objective marked not strictly convex may still be convex.

# Examples
```julia
using MOProblems

filter_problems(name_pattern = r"^ZDT", max_vars = 10)
filter_problems(has_bounds = true, has_jacobian = true)
filter_problems(any_strictly_convex = true, all_strictly_convex = false)
```

See also [`get_problem_names`](@ref), [`ProblemMeta`](@ref),
[`default_nvar`](@ref), [`default_nobj`](@ref).
"""
function filter_problems(;
    name_pattern::Union{Nothing, AbstractString, Regex} = nothing,
    min_vars::Int = 0,
    max_vars::Int = typemax(Int),
    min_objs::Int = 0,
    max_objs::Int = typemax(Int),
    dimension_type::Union{Nothing, Type{<:AbstractDimensionSpec}} = nothing,
    has_bounds::Union{Nothing, Bool} = nothing,
    has_jacobian::Union{Nothing, Bool} = nothing,
    has_hessian::Union{Nothing, Bool} = nothing,
    min_con_eq::Int = 0,
    max_con_eq::Int = typemax(Int),
    min_con_ineq::Int = 0,
    max_con_ineq::Int = typemax(Int),
    has_constraint_jacobian::Union{Nothing, Bool} = nothing,
    has_constraint_hessian::Union{Nothing, Bool} = nothing,
    any_strictly_convex::Union{Nothing, Bool} = nothing,
    all_strictly_convex::Union{Nothing, Bool} = nothing
)
    names = String[]
    strict_convexity_requested =
        !isnothing(any_strictly_convex) || !isnothing(all_strictly_convex)

    for (pname, meta) in META
        if !isnothing(name_pattern) && !occursin(name_pattern, pname)
            continue
        end

        if !isnothing(dimension_type) && !(meta.dimension isa dimension_type)
            continue
        end

        # Numeric dimension filters refer to the default instance.
        nvar = default_nvar(meta)
        if !(min_vars <= nvar <= max_vars)
            continue
        end

        nobj = default_nobj(meta)
        if !(min_objs <= nobj <= max_objs)
            continue
        end

        if !isnothing(has_bounds) && (has_bounds != meta.has_bounds)
            continue
        end

        if !isnothing(has_jacobian) && (has_jacobian != meta.has_jacobian)
            continue
        end

        if !isnothing(has_hessian) && (has_hessian != meta.has_hessian)
            continue
        end

        if !(min_con_eq <= meta.ncon_eq <= max_con_eq)
            continue
        end

        if !(min_con_ineq <= meta.ncon_ineq <= max_con_ineq)
            continue
        end

        if !isnothing(has_constraint_jacobian) &&
           (has_constraint_jacobian != meta.has_constraint_jacobian)
            continue
        end

        if !isnothing(has_constraint_hessian) &&
           (has_constraint_hessian != meta.has_constraint_hessian)
            continue
        end

        # A requested strict-convexity predicate requires available information.
        strict_convexity_vec = meta.strict_convexity
        if strict_convexity_requested && isnothing(strict_convexity_vec)
            continue
        end

        if !isnothing(any_strictly_convex)
            has_strict = any(c -> c === :strictly_convex, strict_convexity_vec)
            if any_strictly_convex != has_strict
                continue
            end
        end

        if !isnothing(all_strictly_convex)
            all_strict = all(c -> c === :strictly_convex, strict_convexity_vec)
            if all_strictly_convex != all_strict
                continue
            end
        end

        push!(names, pname)
    end

    return sort!(names)
end
