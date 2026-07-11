# Quick Start

```julia
using MOProblems

prob = DTLZ2()
x = rand(prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

Every constructed benchmark has fixed `nvar` and `nobj` fields. The numeric
type of the input vector `x` anchors the numeric type of allocated outputs:

```julia
x32 = rand(Float32, prob.nvar)
values32 = eval_f(prob, x32)
```

For repeated evaluations, use the in-place API and provide buffers with the
same element type as `x`:

```julia
y = Vector{Float64}(undef, prob.nobj)
Jbuf = Matrix{Float64}(undef, prob.nobj, prob.nvar)

eval_f!(y, prob, x)
eval_jacobian!(Jbuf, prob, x)
```

Analytical derivatives are available only when the benchmark registers them.
Unavailable Jacobians or Hessians raise an explicit error.

## Catalog Queries

```julia
get_problem_names()
filter_problems(has_bounds = true)
filter_problems(has_jacobian = true)
filter_problems(dimension_type = ParametricDimension)
```

Numeric dimension filters use the default catalog instance. For example,
`min_vars`, `max_vars`, `min_objs`, and `max_objs` compare against
`default_nvar(meta)` and `default_nobj(meta)`.

The catalog uses four dimension specifications:

- `FixedDimension`: both dimensions are fixed;
- `VariableNvar`: `n` selects `nvar`, while `nobj` is fixed;
- `ParametricDimension`: free formulation parameters derive the dimensions;
- `CoupledDimension`: `nvar` and `nobj` follow a structural relation.
