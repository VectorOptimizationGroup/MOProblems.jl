# Quick Usage and API

MOProblems.jl provides a curated catalog of implemented multi-objective
benchmark problems. The package exposes constructors for the problems included
in the catalog, evaluation functions for objective values and registered
analytical derivatives, and metadata-based query functions.

## API Contract

The supported public workflow is:

1. construct an implemented benchmark problem;
2. evaluate objective values at a vector `x`;
3. evaluate registered analytical Jacobians or Hessians when available;
4. query the benchmark catalog by metadata.

The catalog distinguishes four dimension specifications: `FixedDimension`,
`VariableNvar`, `ParametricDimension`, and `CoupledDimension`. After
construction, every instance has fixed `nvar` and `nobj` values.

The numeric type of the evaluation point `x` defines the numeric type of the
outputs. For example, `Vector{Float32}` input should produce `Float32`
objective values and derivative arrays, while `Vector{Float64}` input should
produce `Float64` outputs.

Derivative evaluation is available when a benchmark has a registered analytical
Jacobian or Hessian. Unavailable derivatives are reported with an explicit
error.

## Usage Example

```julia
using MOProblems

# === Direct Constructors ===

# Create problems
zdt1 = ZDT1()        # ZDT1 with 30 variables (default)
zdt1_50 = ZDT1(50)   # ZDT1 with 50 variables
ap1 = AP1()          # AP1 Problem
dgo1 = DGO1()        # DGO1 Problem

# Check problem properties
println("ZDT1 - Variables: ", zdt1.nvar, ", Objectives: ", zdt1.nobj)

# === Static Queries ===

# List all available problems
names = get_problem_names()
println("Available problems: ", names)

# Filter problems by properties
convex_problems = filter_problems(any_convex=true)
bounded_problems = filter_problems(has_bounds=true)
jacobian_problems = filter_problems(has_jacobian=true)
coupled_problems = filter_problems(dimension_type=CoupledDimension)

println("Problems with convex objectives: ", convex_problems)
println("Problems with bounds: ", bounded_problems)
println("Problems with analytical Jacobian: ", jacobian_problems)

# === Function Evaluation ===

# Create a random point
x = rand(zdt1.nvar)

# Evaluate all objective functions
values = eval_f(zdt1, x)
println("Objective function values: ", values)

# Evaluate a specific objective function
f1 = eval_f(zdt1, x, 1)
println("Value of the first objective function: ", f1)

# Calculate the analytical Jacobian matrix (gradients)
J = eval_jacobian(zdt1, x)
println("Jacobian matrix (", size(J), "):")
display(J)

# Calculate analytical gradient of a specific function
grad1 = eval_jacobian_row(zdt1, x, 1)
println("Gradient of the first objective function: ", grad1)

# Reuse preallocated buffers for repeated evaluations
y = Vector{Float64}(undef, zdt1.nobj)
J_buffer = Matrix{Float64}(undef, zdt1.nobj, zdt1.nvar)

eval_f!(y, zdt1, x)
eval_jacobian!(J_buffer, zdt1, x)
```

## Query Functions

### Function Evaluation

- `eval_f(problem, x)`: Evaluates all objective functions at point x
- `eval_f(problem, x, i)`: Evaluates the i-th objective function at point x
- `eval_f!(y, problem, x)`: Evaluates all objective functions at point x and writes the result to `y`

### Jacobian Evaluation

- `eval_jacobian(problem, x)`: Evaluates the registered analytical Jacobian matrix at point x
- `eval_jacobian_row(problem, x, i)`: Evaluates the registered analytical gradient of the i-th objective function
- `eval_jacobian!(J, problem, x)`: Evaluates the registered analytical Jacobian matrix at point x and writes the result to `J`
- `eval_jacobian_row!(row, problem, x, i)`: Evaluates the registered analytical gradient of the i-th objective function and writes the result to `row`

### Hessian Evaluation

- `eval_hessian(problem, x)`: Evaluates registered analytical Hessian matrices at point x
- `eval_hessian_row(problem, x, i)`: Evaluates the registered analytical Hessian of the i-th objective function
- `eval_hessian!(Hs, problem, x)`: Evaluates registered analytical Hessian matrices at point x and writes the result to `Hs`
- `eval_hessian_row!(H, problem, x, i)`: Evaluates the registered analytical Hessian of the i-th objective function and writes the result to `H`

### Problem Registry

- `get_problem_names()`: Returns the names of all registered problems
- `filter_problems(...)`: Filters problems by specific properties

Numeric filters (`min_vars`, `max_vars`, `min_objs`, and `max_objs`) always use
the default instance dimensions returned by `default_nvar(meta.dimension)` and
`default_nobj(meta.dimension)`. They do not test whether another admissible
dimension exists. Use `dimension_type` to filter by category:

```julia
filter_problems(dimension_type=FixedDimension)
filter_problems(dimension_type=VariableNvar)
filter_problems(dimension_type=ParametricDimension)
filter_problems(dimension_type=CoupledDimension)
```

## Dimension Specifications

- `FixedDimension` has no free dimensional parameter.
- `VariableNvar` exposes `n`; it sets `nvar = n`, while `nobj` is fixed.
- `ParametricDimension` exposes `k` and `m`; for `DTLZ1`--`DTLZ5`,
  `nvar = k + m - 1` and `nobj = m`.
- `CoupledDimension` exposes `n`; `MGH26` and `Toi9` derive `nobj = nvar`,
  while `Toi10` derives `nobj = nvar - 1`.

The constructors follow those natural parameters: DTLZ problems receive `k`
and `m`; `MGH26`, `Toi9`, and `Toi10` receive `n`. Inspect a specification with
`dimension_parameters`, `dimension_relation`, `default_nvar`, and
`default_nobj`.

## Convexity Properties

Per-objective convexity information exists only for fixed-dimension problems:

- `:strictly_convex`: The function is strictly convex
- `:convex`: The function is convex, but not necessarily strictly
- `:non_convex`: The function is not convex

For every non-fixed dimension specification, `meta.convexity === nothing`.
Requesting any convexity filter excludes those problems; absence is not treated
as evidence that a requested property is false.
