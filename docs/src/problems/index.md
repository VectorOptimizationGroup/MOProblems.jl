# Problem Families

MOProblems.jl groups benchmark constructors by their source family or
publication. Each constructor returns an `MOProblem` instance with effective
dimensions, objective callables, bounds when available, and registered
analytical derivatives when implemented.

## Documented families

- [DTLZ](@ref): scalable test problems from Deb, Thiele, Laumanns, and Zitzler
  [Deb2005](@cite).
