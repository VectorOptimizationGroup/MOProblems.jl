# Catalog and Metadata

This guide follows a benchmark-selection workflow: find candidates, interpret
their static metadata, and construct an instance for an experiment. For the
complete keyword list and function contracts, see [`filter_problems`](@ref)
and [`get_problem_names`](@ref) in the [API Reference](@ref).

## Select candidates for an experiment

Suppose an experiment needs a ZDT problem with variable bounds and an
analytical objective Jacobian. Query the catalog before constructing any
instances:

```jldoctest catalog_workflow
julia> using MOProblems

julia> candidates = filter_problems(
           name_pattern = r"^ZDT",
           has_bounds = true,
           has_jacobian = true,
       )
5-element Vector{String}:
 "ZDT1"
 "ZDT2"
 "ZDT3"
 "ZDT4"
 "ZDT6"
```

These names identify candidates to investigate. The query checks registered
properties; consult the [ZDT family page](../problems/zdt.md) for the
formulations, bounds, constructor parameters, and derivative-domain
restrictions before choosing one.

## Interpret the catalog defaults

Inspect the [`ProblemMeta`](@ref MOProblems.ProblemMeta) entry for `ZDT1` in `META`:

```jldoctest catalog_workflow
julia> meta = META["ZDT1"];

julia> typeof(meta.dimension)
VariableNvar

julia> default_nvar(meta)
30

julia> default_nobj(meta)
2
```

The default has 30 variables and two objectives. Its `VariableNvar`
specification means that the constructor can select a different number of
variables while keeping the objective count fixed.

If the experiment is limited to ten variables, adding a numeric filter
selects problems whose **default instances** meet that limit:

```jldoctest catalog_workflow
julia> small_defaults = filter_problems(
           name_pattern = r"^ZDT",
           has_bounds = true,
           has_jacobian = true,
           max_nvar = 10,
       )
2-element Vector{String}:
 "ZDT4"
 "ZDT6"
```

`ZDT1` is absent because its default has 30 variables. This does not rule out
using a smaller `ZDT1` instance: the catalog query does not search the
constructor's supported configurations.

## Construct the chosen instance

The [`ZDT1`](@ref) constructor accepts `nvar >= 2`, so it can still be used in the
ten-variable experiment:

```jldoctest catalog_workflow
julia> prob = ZDT1(nvar = 10);

julia> prob.nvar
10

julia> prob.nobj
2

julia> default_nvar(meta)
30
```

The constructed instance has ten variables and two objectives; the catalog
default remains 30 variables. Once constructed, each instance has fixed
`nvar` and `nobj` fields. Continue with [Evaluation and Derivatives](@ref) to
evaluate the chosen instance.

## Obtain a box for an initial point

[`recommended_bounds`](@ref) returns a finite box that can be used to define a
sampling region. For a problem with registered variable bounds, it returns
those bounds. Otherwise, it returns a working box recommended by the package
developers; this box is not part of the problem definition and does not modify
`prob.bounds`.

A recommended working box specifies only coordinate intervals. It does not
guarantee that every point satisfies the problem constraints, admits
well-defined objective and derivative evaluations, or lies near the Pareto set.
These properties must be checked separately when required by an experiment.

```jldoctest catalog_workflow
julia> using Random

julia> bounded = ZDT1();

julia> recommended_bounds(bounded) == bounded.bounds
true

julia> prob = Lov5();

julia> isnothing(prob.bounds)
true

julia> lower, upper = recommended_bounds(prob)
([-2.0, -2.0, -2.0], [2.0, 2.0, 2.0])

julia> rng = MersenneTwister(1234);

julia> α = rand(rng, prob.nvar);

julia> x = lower .+ α .* (upper .- lower);

julia> values = eval_f(prob, x);

julia> (length(x), length(values), all((lower .<= x) .& (x .<= upper)))
(3, 2, true)
```

Passing a problem name returns the box for the default dimensions. Passing an
instance returns vectors compatible with `prob.nvar`, including supported
non-default dimensions.

## Apply the workflow to other families

For a study that varies problem size, use the dimension specification to
identify which dimensions a family can change. The `dimension_type` keyword
of [`filter_problems`](@ref) selects one of these categories:

| Specification | Dimension choices |
|:--------------|:------------------|
| [`FixedDimension`](@ref) | `nvar` and `nobj` are fixed. |
| [`VariableNvar`](@ref) | Select `nvar`; `nobj` is fixed. |
| [`VariableNobj`](@ref) | Select `nobj`; `nvar` is fixed. |
| [`IndependentDimension`](@ref) | Select `nvar` and `nobj` independently. |
| [`ParametricDimension`](@ref) | Select `k` and `nobj`; `nvar = k + nobj - 1`. |
| [`CoupledDimension`](@ref) | Select `nvar`; `nobj` changes while `nvar - nobj` remains fixed. |

The family documentation gives the constructor syntax and admissible
parameter values for each candidate. A dimension category alone does not
specify which sizes are valid.

Metadata availability also affects the selection of an experimental set.
For example, a strict-convexity query excludes problems whose
`meta.strict_convexity` is `nothing`, even when requesting `false`. Such an
exclusion reflects unavailable information, rather than evidence about the
objectives' convexity. See [`filter_problems`](@ref) for the precise predicates
and [`ProblemMeta`](@ref MOProblems.ProblemMeta) for the metadata representation.
