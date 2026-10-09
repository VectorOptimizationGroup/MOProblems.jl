# Contributing to MultiObjectiveProblems.jl

Contributions are welcome through GitHub issues and pull requests. Bug reports
should include the Julia version, a minimal reproducer, the observed result,
and the expected result or source when applicable.

## Development setup

MultiObjectiveProblems.jl supports Julia 1.10 and later. From a local checkout, run the
fast test suite with:

```bash
julia --project -e 'using Pkg; Pkg.test()'
```

Before submitting a pull request that changes runtime behavior, also run the
full dimension sweep:

```bash
MO_FAST=0 julia --project -e 'using Pkg; Pkg.test()'
```

See [`test/README.md`](test/README.md) for the purpose and evidence class of
each suite. Documentation changes should follow the build instructions in
[`docs/README.md`](docs/README.md); runnable examples must pass as doctests.

## Pull requests

- Keep each pull request focused and explain the problem it solves.
- Add or update tests for behavior changes and bug fixes.
- Update public documentation when an API or mathematical formulation changes.
- Add an entry under `Unreleased` in [`CHANGELOG.md`](CHANGELOG.md) for a
  user-visible change.
- Do not include generated documentation, local manifests, or unrelated
  formatting changes.

## Adding or changing a benchmark problem

The implementation and documentation must identify the scientific source and
distinguish the published formulation from deliberate package conventions.
Check, as applicable:

- at least one objective value computed independently from the source;
- deliberate deviations such as negated maximization objectives, corrected
  formulas, or different bounds;
- points where a derivative is undefined and a finite result immediately
  inside its domain;
- rejected constructor arguments and resulting dimensions;
- expected catalog entries in `test/catalog/listings.jl`;
- formulas, constructor docstrings, family documentation, and bibliography.

Finite-difference agreement verifies consistency with the implemented function;
it does not replace comparison with the scientific source.

## Maintenance and licensing

Supported Julia versions are defined by `Project.toml` and exercised by
continuous integration. Report correctness issues through a GitHub issue with
enough detail to reproduce them.

By submitting a contribution, you agree that it may be distributed under the
project's [MIT License](LICENSE).
