# Catalog and Metadata

MOProblems.jl stores static information about each benchmark in `META`. The
catalog API supports name-based and property-based discovery without requiring
every problem to be instantiated first.

## List and filter problems

```julia
using MOProblems

names = get_problem_names()
dtlz_names = filter_problems(name_pattern = r"^DTLZ")
bounded = filter_problems(has_bounds = true)
bounded_with_jacobians = filter_problems(
    has_bounds = true,
    has_jacobian = true,
)
```

All supplied criteria are combined. Other filters cover default dimensions,
constraint counts, registered Hessians, constraint derivatives, and
strict-convexity metadata. See [`filter_problems`](@ref) for the complete
keyword list.

## Dimension specifications

Every catalog entry owns one explicit dimension specification:

- `FixedDimension`: `nvar` and `nobj` are fixed;
- `VariableNvar`: `n` selects `nvar`, while `nobj` remains fixed;
- `ParametricDimension`: formulation parameters derive both dimensions;
- `CoupledDimension`: selecting `nvar` determines `nobj` through a structural
  relation.

Dimension categories can be filtered directly:

```julia
fixed = filter_problems(dimension_type = FixedDimension)
parametric = filter_problems(dimension_type = ParametricDimension)
```

Constructor parameters follow the corresponding formulation. For example:

```julia
zdt = ZDT1(50)                # nvar = 50, nobj = 2
dtlz = DTLZ2(k = 8, m = 4)   # nvar = 11, nobj = 4
toi = Toi10(n = 6)            # nvar = 6, nobj = 5
```

Once constructed, every problem instance has fixed `nvar` and `nobj` fields.

## Defaults and numeric filters

Numeric catalog filters compare against the default instance represented by
the metadata:

```julia
meta = META["DTLZ2"]
nvar = default_nvar(meta)
nobj = default_nobj(meta)

small_defaults = filter_problems(max_vars = 5, max_objs = 3)
```

Changing constructor parameters does not change the static catalog default.

## Structural metadata

`ProblemMeta` records bounds, constraints, derivative registration, dimension
information, and per-objective strict-convexity information when available.
For example:

```julia
meta = META["AP1"]

meta.has_bounds
meta.has_jacobian
meta.strict_convexity
```

The recognized strict-convexity values are `:strictly_convex` and
`:not_strictly_convex`. A value of `nothing` means that reliable information
is not available for the complete objective vector. Problems with unavailable
information are excluded whenever a strict-convexity filter is requested,
including when the requested predicate is `false`.
