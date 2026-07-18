# Quick Start

After [installing MOProblems.jl](@ref Installation), load the package and
construct a benchmark:

```julia
using MOProblems

prob = DTLZ2()
```

Every constructed benchmark exposes its effective dimensions and available
variable bounds:

```julia
prob.nvar
prob.nobj
prob.bounds
```

Create a point and evaluate the objective vector and registered analytical
Jacobian:

```julia
x = rand(prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

The result has `length(values) == prob.nobj` and
`size(J) == (prob.nobj, prob.nvar)`. Each Jacobian row is the gradient of one
objective.

Use the catalog to discover another benchmark by the properties required by a
workflow:

```julia
names = filter_problems(
    has_bounds = true,
    has_jacobian = true,
    max_objs = 3,
)
```

Continue with [Evaluation and Derivatives](@ref) for preallocation, numeric
types, and derivative behavior, or [Catalog and Metadata](@ref) for dimensions
and advanced queries. The [Problem Families](@ref) pages contain the
implemented mathematical formulations and benchmark-specific details.
