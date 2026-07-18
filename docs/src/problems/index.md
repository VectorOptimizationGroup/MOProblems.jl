# Problem Families

MOProblems.jl groups benchmark constructors by their source family or
publication. Each constructor returns an `MOProblem` instance with effective
dimensions, objective and constraint callables, variable and constraint bounds
when available, and registered analytical derivatives when implemented.

## Documented families

- [Amaral–Assunção–Souza (AAS)](@ref): two fixed-dimension problems
  from Amaral, Assunção, and Souza
  [AAS2025](@cite).
- [Ansary–Panda (AP)](@ref): four fixed-dimension problems from
  Md. A. T. Ansary and G. Panda
  [AP2014](@cite).
- [Binh–Korn (BK)](@ref): one fixed-dimension problem from To Thanh Binh and
  Ulrich Korn
  [BK1996](@cite).
- [Das–Dennis (DD)](@ref): one constrained, fixed-dimension problem from
  Indraneel Das and J. E. Dennis.
  [DD1998](@cite).
- [Dumitrescu-Grosan-Oltean (DGO)](@ref): three fixed-dimension problems from
  Crina Grosan, Dan Dumitrescu, and Mihai Oltean
  [DGO2000](@cite).
- [Deb–Thiele–Laumanns–Zitzler (DTLZ)](@ref): scalable test problems from Deb,
  Thiele, Laumanns, and Zitzler
  [DTLZ2005](@cite).
- [Farhang-Mehr-Azarm (FA)](@ref): one fixed-dimension problem from
  A. Farhang-Mehr and S. Azarm
  [FA2002](@cite).
