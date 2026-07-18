# Installation

## Install from GitHub

Add MOProblems.jl to the active Julia environment directly from its GitHub
repository:

```julia
import Pkg
Pkg.add(url = "https://github.com/VectorOptimizationGroup/MOProblems.jl")
```

Using a project-specific environment is recommended so that the package
version is recorded alongside the rest of the project's dependencies. See the
Julia `Pkg` documentation for environment creation and activation.

## Install from a local checkout

Clone the repository when you need a local copy of the source:

```bash
git clone https://github.com/VectorOptimizationGroup/MOProblems.jl.git
```

To install that checkout into the active Julia environment, provide its local
path:

```julia
import Pkg
Pkg.add(path = "/absolute/path/to/MOProblems.jl")
```

Use `Pkg.develop(path = ...)` instead when local source edits should be visible
immediately from the active environment.

## Verify the installation

```julia
using MOProblems

prob = ZDT1()
values = eval_f(prob, rand(prob.nvar))
```

Continue with the [Quick Start](@ref) for the main construction, evaluation,
and catalog workflow.
