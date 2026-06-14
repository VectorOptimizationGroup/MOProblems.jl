"""
    Query and discovery functions for multiobjective optimization problems.

This module provides functions to query and filter available multiobjective 
optimization problems based on their static metadata (`META`).
"""

"""
    get_problem_names()

Return the names of all available problems.

This function queries the static metadata (`META`) to list all problems 
implemented in the package, regardless of whether they have been instantiated.

# Returns
A vector of strings containing the names of all available problems.

# Example
```julia
names = get_problem_names()
println("Available problems: ", names)

# Filter problems by properties
convex_problems = filter_problems(any_convex=true)
bounded_problems = filter_problems(has_bounds=true)
```
"""
function get_problem_names()
    return collect(keys(META))
end

"""
    filter_problems(;
        name_pattern::Union{Nothing, String, Regex} = nothing,
        min_vars::Int = 0,
        max_vars::Int = typemax(Int),
        min_objs::Int = 0,
        max_objs::Int = typemax(Int),
        has_bounds::Union{Nothing, Bool} = nothing,
        has_jacobian::Union{Nothing, Bool} = nothing,
        has_hessian::Union{Nothing, Bool} = nothing,
        m_objtype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
        origin::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
        any_strictly_convex::Union{Nothing, Bool} = nothing,
        all_strictly_convex::Union{Nothing, Bool} = nothing,
        any_convex::Union{Nothing, Bool} = nothing,
        all_convex::Union{Nothing, Bool} = nothing,
        all_non_convex::Union{Nothing, Bool} = nothing
    )

Filter problems based on specific criteria.

# Arguments
- `name_pattern::Union{Nothing, String, Regex}`: pattern to match problem names.
- `min_vars::Int`: minimum number of variables.
- `max_vars::Int`: maximum number of variables.
- `min_objs::Int`: minimum number of objectives.
- `max_objs::Int`: maximum number of objectives.
- `has_bounds::Union{Nothing, Bool}`: whether the problem has bounds.
- `has_jacobian::Union{Nothing, Bool}`: whether the problem has an analytical Jacobian.
- `has_hessian::Union{Nothing, Bool}`: whether the problem has an analytical Hessian.
- `m_objtype::Union{Nothing, Symbol, Vector{Symbol}}`: multi-objective type.
- `origin::Union{Nothing, Symbol, Vector{Symbol}}`: problem origin.
- `any_strictly_convex::Union{Nothing, Bool}`: whether at least one objective is strictly convex.
- `all_strictly_convex::Union{Nothing, Bool}`: whether all objectives are strictly convex.
- `any_convex::Union{Nothing, Bool}`: whether at least one objective is convex.
- `all_convex::Union{Nothing, Bool}`: whether all objectives are convex.
- `all_non_convex::Union{Nothing, Bool}`: whether all objectives are non-convex.

# Returns
A sorted list of problem names satisfying all criteria.
"""
function filter_problems(;
    name_pattern::Union{Nothing, String, Regex} = nothing,
    min_vars::Int = 0,
    max_vars::Int = typemax(Int),
    min_objs::Int = 0,
    max_objs::Int = typemax(Int),
    has_bounds::Union{Nothing, Bool} = nothing,
    has_jacobian::Union{Nothing, Bool} = nothing,
    has_hessian::Union{Nothing, Bool} = nothing,
    m_objtype::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
    origin::Union{Nothing, Symbol, Vector{Symbol}} = nothing,
    any_strictly_convex::Union{Nothing, Bool} = nothing,
    all_strictly_convex::Union{Nothing, Bool} = nothing,
    any_convex::Union{Nothing, Bool} = nothing,
    all_convex::Union{Nothing, Bool} = nothing,
    all_non_convex::Union{Nothing, Bool} = nothing
)
    names = String[]
    for (pname, meta) in META
        # Filter by name pattern
        if !isnothing(name_pattern)
            if name_pattern isa Regex
                if !occursin(name_pattern, pname)
                    continue
                end
            else
                if !occursin(String(name_pattern), pname)
                    continue
                end
            end
        end
        
        # Filter by number of variables
        nvar = meta.nvar
        if !(min_vars <= nvar <= max_vars)
            continue
        end
        
        # Filter by number of objectives
        nobj = meta.nobj
        if !(min_objs <= nobj <= max_objs)
            continue
        end
        

        
        # Filter by presence of bounds
        if !isnothing(has_bounds) && (has_bounds != meta.has_bounds)
            continue
        end
        
        # Filter by presence of Jacobian
        if !isnothing(has_jacobian) && (has_jacobian != meta.has_jacobian)
            continue
        end

        # Filter by presence of Hessian
        if !isnothing(has_hessian) && (has_hessian != meta.has_hessian)
            continue
        end
        
        # Filter by multi-objective type
        if !isnothing(m_objtype)
            if m_objtype isa Symbol
                if meta.m_objtype != m_objtype
                    continue
                end
            else
                if !(meta.m_objtype in m_objtype)
                    continue
                end
            end
        end
        

        
        # Filter by origin
        if !isnothing(origin)
            if origin isa Symbol
                if meta.origin != origin
                    continue
                end
            else
                if !(meta.origin in origin)
                    continue
                end
            end
        end
        
        # Filter by convexity
        convexity_vec = meta.convexity
        
        if !isnothing(any_strictly_convex)
            has_strict = any(c -> c === :strictly_convex, convexity_vec)
            if any_strictly_convex != has_strict
                continue
            end
        end
        
        if !isnothing(all_strictly_convex)
            all_strict = all(c -> c === :strictly_convex, convexity_vec)
            if all_strictly_convex != all_strict
                continue
            end
        end
        
        if !isnothing(any_convex)
            has_convex = any(c -> c === :convex || c === :strictly_convex, convexity_vec)
            if any_convex != has_convex
                continue
            end
        end
        
        if !isnothing(all_convex)
            all_conv = all(c -> c === :convex || c === :strictly_convex, convexity_vec)
            if all_convex != all_conv
                continue
            end
        end
        
        if !isnothing(all_non_convex)
            all_non_conv = all(c -> c === :non_convex, convexity_vec)
            if all_non_convex != all_non_conv
                continue
            end
        end
        
        push!(names, pname)
    end
    
    return sort(names)
end
