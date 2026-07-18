# MOProblems.jl

MOProblems.jl is a curated Julia library of benchmark problems for
multiobjective optimization. It provides source-traceable problem
implementations, a consistent evaluation API, registered analytical
derivatives, and metadata-based catalog queries.

## Installation

```julia
import Pkg
Pkg.add(url = "https://github.com/VectorOptimizationGroup/MOProblems.jl")
```

See the [installation guide](https://vectoroptimizationgroup.github.io/MOProblems.jl/dev/installation/)
for project environments and local checkouts.

## Quick Example

```julia
using MOProblems

prob = DTLZ2()
x = rand(prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)

names = filter_problems(has_jacobian = true)
```

## Documentation

The [MOProblems.jl documentation](https://vectoroptimizationgroup.github.io/MOProblems.jl/dev/)
contains the quick start, task-oriented guides, mathematical formulations,
API reference, and bibliography. Instructions for building it locally are in
[`docs/README.md`](docs/README.md).

## Highlights

- Curated, source-traceable benchmark implementations.
- Allocating and in-place APIs for objectives and registered derivatives.
- Catalog filters for dimensions, bounds, constraints, and derivative support.
- Per-family formulations, metadata, usage examples, and references.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue to discuss improvements or report bugs.
