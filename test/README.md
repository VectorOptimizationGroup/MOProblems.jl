# Test suite

## Running

```bash
julia --project -e 'using Pkg; Pkg.test()'            # dimensions {5, 10}
MO_FAST=0 julia --project -e 'using Pkg; Pkg.test()'  # dimensions {5, 10, 20, 30, 50}
```

A single suite, with [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl):

```julia
using TestEnv; TestEnv.activate()
using Test, MOProblems
include("test/TestUtils.jl")
include("test/dimensions/variable_dimension.jl")
```

## Suites

Evidence: *structural* (shapes and metadata agree), *finite differences*
(derivative vs. the implemented function), *reference value* (compared with a
value obtained independently of the implementation).

| Suite | Checks | Evidence |
| --- | --- | --- |
| `contracts/problem_definitions.jl` | every registered problem against its `META` entry, at its default size and at each swept dimension | structural |
| same file, per-family testsets | source conventions (sign of maximization objectives, corrected formulas, bounds) | reference value |
| `interface/numeric_type_contract.jl` | output float type follows the input, for allocating, in-place and per-row evaluators | structural |
| `jacobians/analytic_vs_fd.jl` | every registered Jacobian | finite differences |
| same file, `… Jacobian domain` testsets | `DomainError` where a Jacobian row is undefined | reference value |
| `hessians/H_analytic_vs_fd.jl` | every registered Hessian | finite differences |
| `constraints/evaluation.jl` | constraint API | reference value |
| `catalog/listings.jl` | `filter_problems`, `recommended_bounds`, metadata | reference value |
| `dimensions/variable_dimension.jl` | `nvar`/`nobj` versus constructor keywords, rejected arguments | reference value |

## Derivative checks

The reference is a central difference in `BigFloat` (256 bits); in `Float64`
its own error exceeds the tolerance. Criterion:
`norm(A - B) / max(norm(B), 1e-8) <= 1e-10`.

Derivatives are compared at a reproducible pseudo-random point in the box
given by `recommended_bounds` (`TestUtils.sample_x`); Hessians of problems with
`n ≤ 2` are also checked on a 3×3 grid in that box.

