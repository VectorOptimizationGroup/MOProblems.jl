# MOProblems.jl

A Julia library of benchmark multi-objective (vector-valued) optimization problems with per-objective analytic gradients and metadata for filtering by convexity, bounds, and problem dimensions.

MOProblems.jl provides a curated catalog of implemented benchmark problems and
a focused evaluation API for objective values, registered analytical
derivatives, and metadata-based problem queries.

## Installation

```julia
import Pkg
Pkg.add(url="https://github.com/VectorOptimizationGroup/MOProblems.jl")
```

If installation via URL fails, you can install the package from a local clone of the repository.

First, clone the repository to a directory of your choice:

```bash
git clone https://github.com/VectorOptimizationGroup/MOProblems.jl
```

This command will create a local directory named `MOProblems.jl`.

Next, decide whether you want to install the package in a specific Julia project (recommended) or in the global environment. In both cases, install it by explicitly pointing to the local path of the cloned repository.

```julia
import Pkg
Pkg.add(path="/path/to/MOProblems.jl")
```

**Important**
- Replace `/path/to/MOProblems.jl` with the actual location where the repository was cloned on your system.

## Usage Example

```julia
using MOProblems

zdt1 = ZDT1()               # 30 variables, 2 objectives
zdt1_50 = ZDT1(50)          # 50 variables, 2 objectives
x = rand(zdt1.nvar)
values = eval_f(zdt1, x)    # evaluate objective functions
J = eval_jacobian(zdt1, x)  # analytical jacobian, when implemented
names = filter_problems(has_jacobian=true)
```

For repeated evaluations, MOProblems.jl also provides in-place variants that
write into user-provided buffers:

```julia
y = Vector{Float64}(undef, zdt1.nobj)
J = Matrix{Float64}(undef, zdt1.nobj, zdt1.nvar)

eval_f!(y, zdt1, x)
eval_jacobian!(J, zdt1, x)
```

## API Contract

The public API is centered on benchmark construction, evaluation, and catalog
queries:

- construct one of the implemented benchmark problems, such as `ZDT1()` or `ZDT1(50)`;
- evaluate objective values with `eval_f`;
- evaluate registered analytical derivatives with `eval_jacobian`,
  `eval_jacobian_row`, `eval_hessian`, and `eval_hessian_row`;
- use the corresponding in-place methods `eval_f!`, `eval_jacobian!`,
  `eval_jacobian_row!`, `eval_hessian!`, and `eval_hessian_row!` when you want
  to reuse preallocated output buffers;
- query the benchmark catalog with `get_problem_names` and `filter_problems`.

Catalog dimensions are represented explicitly by `meta.dimension`:

- `FixedDimension`: both dimensions are fixed;
- `VariableNvar`: `n` directly selects `nvar`, while `nobj` is fixed;
- `ParametricDimension`: free formulation parameters derive both dimensions;
- `CoupledDimension`: `nvar` is selected and `nobj` follows a structural relation.

`DTLZ1`--`DTLZ5` receive `k` and `m`, with `nvar = k + m - 1` and
`nobj = m`. `MGH26` and `Toi9` receive `n` and use `nobj = nvar`; `Toi10`
receives `n` and uses `nobj = nvar - 1`. Once constructed, every problem
instance has fixed `nvar` and `nobj` values.

Use `default_nvar(meta)` and `default_nobj(meta)` for catalog defaults, and
`dimension_parameters(meta)` and `dimension_relation(meta)` to inspect free
parameters and derived dimensions. Numeric catalog filters use these default
dimensions. Dimension categories can be selected directly:

```julia
fixed = filter_problems(dimension_type=FixedDimension)
parametric = filter_problems(dimension_type=ParametricDimension)
```

Per-objective convexity metadata is available only for `FixedDimension`.
Non-fixed problems have `meta.convexity === nothing` and are excluded whenever
a convexity filter is requested, including filters whose requested value is
`false`.

Evaluation should preserve the numeric type of the input vector `x`. For
example, evaluating a problem at `Vector{Float32}` should return `Float32`
objective values and derivative arrays; evaluating at `Vector{Float64}` should
return `Float64` outputs.

Derivative evaluation is available when an analytical implementation is
registered for the benchmark. Unavailable derivatives are reported with an
explicit error.

## Documentation

- [`docs/README.md`](docs/README.md): Index of the documentation in Markdown.
- [`docs/api.md`](docs/api.md): Features, recommended interface, and utility functions.
- [`docs/problems.md`](docs/problems.md): Complete list and summary table of implemented problems.
- [`docs/references.md`](docs/references.md): Articles and formulation sources.

Once the HTML site (Documenter.jl) is published, these Markdown files will serve as the primary source.

## Features

- Large library of benchmark multi-objective problems  
- Analytic gradients per objective when available  
- Unified API for evaluating objectives and registered analytical derivatives
- Metadata for filtering (convexity, bounds, dimensions, Jacobians)  
- Benchmark catalog with name-based and property-based queries
- Explicit fixed, directly variable, parametric, and coupled dimension specifications
## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue to discuss improvements or report bugs.
