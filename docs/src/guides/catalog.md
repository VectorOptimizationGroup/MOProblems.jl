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
           max_vars = 10,
       )
2-element Vector{String}:
 "ZDT4"
 "ZDT6"
```

`ZDT1` is absent because its default has 30 variables. This does not rule out
using a smaller `ZDT1` instance: the catalog query does not search the
constructor's supported configurations.

## Construct the chosen instance

The [`ZDT1`](@ref) constructor accepts `n >= 2`, so it can still be used in the
ten-variable experiment:

```jldoctest catalog_workflow
julia> prob = ZDT1(10);

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

## Apply the workflow to other families

For a study that varies problem size, use the dimension specification to
identify which dimensions a family can change. The `dimension_type` keyword
of [`filter_problems`](@ref) selects one of these categories:

| Specification | Dimension choices |
|:--------------|:------------------|
| [`FixedDimension`](@ref) | Both dimensions are fixed. |
| [`VariableNvar`](@ref) | Select the variable count; the objective count is fixed. |
| [`VariableNobj`](@ref) | Select the objective count; the variable count is fixed. |
| [`IndependentDimension`](@ref) | Select the two dimensions independently. |
| [`ParametricDimension`](@ref) | Formulation parameters determine both dimensions. |
| [`CoupledDimension`](@ref) | Selecting the variable count determines the objective count through a structural relation. |

The family documentation gives the constructor syntax and admissible
parameter values for each candidate. A dimension category alone does not
specify which sizes are valid.

Metadata availability also affects the selection of an experimental set.
For example, a strict-convexity query excludes problems whose
`meta.strict_convexity` is `nothing`, even when requesting `false`. Such an
exclusion reflects unavailable information, rather than evidence about the
objectives' convexity. See [`filter_problems`](@ref) for the precise predicates
and [`ProblemMeta`](@ref MOProblems.ProblemMeta) for the metadata representation.
