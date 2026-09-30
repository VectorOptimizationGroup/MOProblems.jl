# Test suite

Notes for maintainers: how to run the suite, what each file guarantees, and
what a new problem has to satisfy.

## Running

```bash
# Fast mode: variable-dimension problems are swept over {5, 10}
julia --project -e 'using Pkg; Pkg.test()'

# Full mode: {5, 10, 20, 30, 50}
MO_FAST=0 julia --project -e 'using Pkg; Pkg.test()'
```

`Pkg.test()` builds the test environment from `test/Project.toml` and adds the
package itself, so `test/Project.toml` must not list `MOProblems`, and no
`test/Manifest.toml` is needed.

To run a single suite, activate the test environment with
[TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl) (installed in your
global environment) from a session started with `julia --project`:

```julia
using TestEnv; TestEnv.activate()
using Test, MOProblems
include("test/TestUtils.jl")
include("test/dimensions/variable_dimension.jl")
```

CI (`.github/workflows/CI.yml`) runs the fast mode on every supported Julia
release and platform, and the full mode once, on the LTS.

## What each suite guarantees

`runtests.jl` includes `TestUtils.jl` and then every suite below. There are
three kinds of evidence, and they are not interchangeable:

- **structural** — shapes, sizes and metadata agree with each other;
- **self-consistency** — a registered derivative agrees with finite differences
  of the implemented function. This does not show that the function matches its
  source paper;
- **independent value** — the result is compared with a value written down
  independently of the implementation, from the source or derived by hand.

| Suite | Guarantees | Evidence |
| --- | --- | --- |
| `contracts/problem_definitions.jl` | every registered problem matches its `META` entry, at its default size and at each swept dimension | structural |
| same file, per-family testsets | source conventions of specific families (sign of maximization objectives, corrected formulas, bounds) | independent value |
| `interface/numeric_type_contract.jl` | the float type of `x` is the float type of every output, for allocating, in-place and per-row evaluators | structural |
| `jacobians/analytic_vs_fd.jl` | every registered Jacobian agrees with finite differences | self-consistency |
| same file, `… Jacobian domain` testsets | points where a Jacobian row is undefined raise `DomainError`, and the function itself stays finite there | independent value |
| `hessians/H_analytic_vs_fd.jl` | every registered Hessian agrees with finite differences | self-consistency |
| `constraints/evaluation.jl` | the constraint API: values, Jacobian, Hessians, in-place forms | independent value |
| `catalog/listings.jl` | `filter_problems`, `recommended_bounds` and the metadata they read | independent value |
| `dimensions/variable_dimension.jl` | how `nvar` and `nobj` respond to the constructor keywords, and which arguments are rejected | independent value |

## Derivative checks

`TestUtils.check_jacobian` and `check_hessian` evaluate the analytical
derivative in `Float64`, as callers do, and compare it with central differences
taken in `BigFloat` (256 bits). A `Float64` difference is not accurate enough to
serve as the reference: its own error exceeds the tolerance applied here.

The comparison is `norm(A - B) / max(norm(B), ATOL) <= RTOL`, with
`ATOL = 1e-8` and `RTOL = 1e-10`. `ATOL` only floors the denominator, for
derivatives that are numerically zero over their box.

Sample points come from `TestUtils.sample_x`: uniform inside the problem's box
with a fixed seed, infinite bounds replaced by `±5`, and `[-1, 1]ⁿ` when the
problem has no box. Jacobians are checked at one point per instance. Hessians
are checked on a `3ⁿ` grid when `n ≤ 2` and at one sampled point otherwise.

## Adding a problem

Checked automatically once the problem is in `META` and exported; nothing to
write:

- shapes and metadata (`contracts/`);
- Jacobian and Hessian against finite differences, if `has_jacobian` /
  `has_hessian` are declared.

To write by hand:

- [ ] at least one objective value taken from the source, at a point where it
      can be computed independently (a known optimum, the origin, a worked
      example). Finite differences cannot detect a formula that was transcribed
      incorrectly;
- [ ] any deliberate departure from the source (negated objective, corrected
      formula, changed bounds), as a test that would fail if it were undone;
- [ ] each point where a derivative is undefined: the `DomainError`, its
      message, and a finite result just inside the domain;
- [ ] constructor arguments that must be rejected, and the resulting sizes for
      variable-dimension problems;
- [ ] the expected lists in `catalog/listings.jl`, if the problem joins a group
      that is enumerated there (dimension type, unbounded problems, constraints).
