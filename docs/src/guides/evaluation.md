# Evaluation and Derivatives

This guide covers objective evaluation, output preallocation, numeric types,
and registered analytical derivatives. Exact signatures and all constraint
evaluation methods are listed in the [API Reference](@ref).

## Allocate outputs

Construct a benchmark and evaluate all of its objectives with `eval_f`:

```julia
using MOProblems

prob = DTLZ2(k = 10, m = 4)
x = rand(prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

The objective vector has length `prob.nobj`. The Jacobian has size
`(prob.nobj, prob.nvar)`, with one objective gradient per row. Use
`eval_jacobian_row(prob, x, i)` when only objective `i` is needed.

Constrained benchmarks expose the same pattern through `eval_c`,
`eval_constraint_jacobian`, and their row-oriented and in-place variants.

## Reuse output buffers

For repeated evaluations, allocate buffers once and use the methods ending in
`!`:

```julia
y = Vector{Float64}(undef, prob.nobj)
Jbuf = Matrix{Float64}(undef, prob.nobj, prob.nvar)

eval_f!(y, prob, x)
eval_jacobian!(Jbuf, prob, x)
```

The buffer dimensions must match the problem, and their element type must
match the element type of `x`.

## Numeric types

The input vector controls the numeric type of allocated objective and
derivative outputs:

```julia
x32 = rand(Float32, prob.nvar)

values32 = eval_f(prob, x32)
J32 = eval_jacobian(prob, x32)
```

Here, both outputs have `Float32` elements. Caller-provided buffers must use
the same type.

## Derivative availability and domains

Analytical Jacobians and Hessians are available only when a benchmark
registers them. Query the catalog before selecting a benchmark when derivative
support is required:

```julia
with_jacobians = filter_problems(has_jacobian = true)
with_hessians = filter_problems(has_hessian = true)
```

Calling a derivative evaluator that is not registered raises an explicit
error. Registration means that an analytical evaluator is provided; it does
not assert differentiability at every boundary point of the benchmark domain.
Family pages document restrictions, and an evaluator may throw a `DomainError`
at a point where the requested derivative is undefined.
