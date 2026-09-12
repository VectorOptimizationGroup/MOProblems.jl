# Quick Start

After [installing MOProblems.jl](@ref Installation), load the package and
construct a benchmark:

```jldoctest quickstart
julia> using MOProblems

julia> prob = DTLZ2();
```

Every constructed benchmark exposes its effective dimensions and available
variable bounds:

```jldoctest quickstart
julia> prob.nvar, prob.nobj, isnothing(prob.bounds)
(12, 3, false)
```

Create a point and evaluate the objective vector and registered analytical
Jacobian:

```jldoctest quickstart
julia> x = fill(0.5, prob.nvar);

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(3, (3, 12))
```

The result has `length(values) == prob.nobj` and
`size(J) == (prob.nobj, prob.nvar)`. Each Jacobian row is the gradient of one
objective.

Use the catalog to discover another benchmark by the properties required by a
workflow:

```jldoctest quickstart
julia> names = filter_problems(
           has_bounds = true,
           has_jacobian = true,
           max_nobj = 3,
       );

julia> length(names)
51
```

Continue with [Evaluation and Derivatives](@ref) for preallocation, numeric
types, and derivative behavior, or [Catalog and Metadata](@ref) for dimensions
and advanced queries. The [Problem Families](@ref) pages contain the
implemented mathematical formulations and benchmark-specific details.
