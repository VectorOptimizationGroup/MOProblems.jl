# Evaluation and Derivatives

This guide covers objective evaluation, registered analytical derivatives,
output preallocation, and numeric types. Exact signatures and all constraint
evaluation methods are listed in the [API Reference](@ref).

## Evaluate objectives and derivatives

Construct the benchmark and evaluate all of its objectives with `eval_f`:

```jldoctest evaluation_workflow
julia> using MOProblems

julia> prob = ZDT1(10);

julia> x = fill(0.5, prob.nvar);

julia> values = eval_f(prob, x)
2-element Vector{Float64}:
 0.5
 3.8416876048223
```

The objective vector has length `prob.nobj`. The Jacobian holds one objective
gradient per row, so its size is `(prob.nobj, prob.nvar)`:

```jldoctest evaluation_workflow
julia> J = eval_jacobian(prob, x);

julia> size(J)
(2, 10)
```

Use `eval_jacobian_row(prob, x, i)` when only objective `i` is needed; it
returns that gradient without forming the full matrix:

```jldoctest evaluation_workflow
julia> eval_jacobian_row(prob, x, 1) == J[1, :]
true
```

Constrained benchmarks expose the same pattern through `eval_c`,
`eval_constraint_jacobian`, and `eval_constraint_jacobian_row`.

## Registered analytical derivatives

Analytical Jacobians and Hessians are available only when a benchmark
registers them. [`ProblemMeta`](@ref MOProblems.ProblemMeta) records the
registration and [`filter_problems`](@ref) queries it, so derivative support
can be checked before any instance is constructed. No ZDT problem registers a
Hessian:

```jldoctest evaluation_workflow
julia> filter_problems(name_pattern = r"^ZDT", has_hessian = true)
String[]

julia> META["ZDT1"].has_hessian
false
```

Calling a derivative evaluator that the benchmark does not register raises an
explicit error, and it does so before `x` or the output buffers are validated:

```jldoctest evaluation_workflow
julia> eval_hessian(prob, x)
ERROR: Analytical Hessian is not registered for problem 'ZDT1'.
```

`AP1` does register Hessians. `eval_hessian` returns one matrix per objective,
each of size `(nvar, nvar)`:

```jldoctest evaluation_workflow
julia> ap = AP1();

julia> xap = fill(0.5, ap.nvar);

julia> H = eval_hessian(ap, xap);

julia> length(H), size(H[1])
(3, (2, 2))

julia> H[1]
2×2 Matrix{Float64}:
 0.75   0.0
 0.0   13.5
```

For a single objective, `eval_hessian_row(ap, xap, i)` returns only the `i`-th
matrix. Constraint Hessians follow the same pair of methods,
`eval_constraint_hessian` and `eval_constraint_hessian_row`.

## Reuse output buffers

Every allocating evaluator has an in-place counterpart whose name ends in `!`.
It writes into a buffer supplied by the caller and returns that same buffer, so
a routine that evaluates one benchmark repeatedly can allocate its outputs once
and reuse them at every point:

```jldoctest evaluation_workflow
julia> y = Vector{Float64}(undef, prob.nobj);

julia> eval_f!(y, prob, x) === y
true

julia> y == values
true
```

The Jacobian buffer is a matrix, and the buffer for a single row is a vector:

```jldoctest evaluation_workflow
julia> Jbuf = Matrix{Float64}(undef, prob.nobj, prob.nvar);

julia> eval_jacobian!(Jbuf, prob, x) == J
true

julia> row = Vector{Float64}(undef, prob.nvar);

julia> eval_jacobian_row!(row, prob, x, 1) == J[1, :]
true
```

Because `eval_hessian` returns one matrix per objective, its buffer is a vector
of matrices, allocated once before the loop that consumes it:

```jldoctest evaluation_workflow
julia> Hs = [Matrix{Float64}(undef, ap.nvar, ap.nvar) for _ in 1:ap.nobj];

julia> eval_hessian!(Hs, ap, xap) === Hs
true

julia> Hs == H
true
```

A single objective needs only one matrix:

```jldoctest evaluation_workflow
julia> Hbuf = Matrix{Float64}(undef, ap.nvar, ap.nvar);

julia> eval_hessian_row!(Hbuf, ap, xap, 1) == H[1]
true
```

The buffer shapes are fixed by the problem dimensions:

| Method | Buffer | Shape |
|:-------|:-------|:------|
| `eval_f!` | vector | `prob.nobj` |
| `eval_c!` | vector | `prob.ncon` |
| `eval_jacobian!` | matrix | `(prob.nobj, prob.nvar)` |
| `eval_constraint_jacobian!` | matrix | `(prob.ncon, prob.nvar)` |
| `eval_jacobian_row!`, `eval_constraint_jacobian_row!` | vector | `prob.nvar` |
| `eval_hessian!` | vector of matrices | `prob.nobj` matrices of `(prob.nvar, prob.nvar)` |
| `eval_constraint_hessian!` | vector of matrices | `prob.ncon` matrices of `(prob.nvar, prob.nvar)` |
| `eval_hessian_row!`, `eval_constraint_hessian_row!` | matrix | `(prob.nvar, prob.nvar)` |

A buffer whose shape does not match raises a `DimensionMismatch`, and its
element type must equal the element type of `x`.

## Numeric types

The input vector controls the numeric type of allocated objective and
derivative outputs:

```jldoctest evaluation_workflow
julia> x32 = fill(0.5f0, prob.nvar);

julia> eltype(eval_f(prob, x32))
Float32

julia> eltype(eval_jacobian(prob, x32))
Float32
```

Both outputs have `Float32` elements. Caller-provided buffers must use the
same type, so a buffer allocated for `Float64` cannot be reused for a
`Float32` evaluation of the same problem.

## Domain restrictions

Registration means that an analytical evaluator is provided; it does not
assert differentiability at every boundary point of the benchmark domain.
Family pages document restrictions, and an evaluator may throw a `DomainError`
at a point where the requested derivative is undefined.
