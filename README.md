# MOProblems.jl

A Julia library of benchmark multi-objective (vector-valued) optimization problems with per-objective analytic gradients and metadata for filtering by convexity, bounds, and problem dimensions.

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
x = rand(zdt1.nvar)
values = eval_f(zdt1, x)    # evaluate objective functions
J = eval_jacobian(zdt1, x)  # jacobian (analytical or finite differences)
names = filter_problems(has_jacobian=true)
```

## Documentation

- [`docs/README.md`](docs/README.md): Index of the documentation in Markdown.
- [`docs/api.md`](docs/api.md): Features, recommended interface, and utility functions.
- [`docs/problems.md`](docs/problems.md): Complete list and summary table of implemented problems.
- [`docs/references.md`](docs/references.md): Articles and formulation sources.

Once the HTML site (Documenter.jl) is published, these Markdown files will serve as the primary source.

## Features

- Large library of benchmark multi-objective problems  
- Analytic gradients per objective when available  
- Unified API for evaluating objectives, constraints, and Jacobians  
- Metadata for filtering (convexity, bounds, dimensions, Jacobians)  
- Central registry with name-based and property-based queries  
- Supports fixed- and variable-dimension test problems  

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue to discuss improvements or report bugs.
