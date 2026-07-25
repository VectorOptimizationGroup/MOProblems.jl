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
- [Farina (Far)](@ref): one fixed-dimension problem originating in M. Farina
  [Far2002](@cite), using the corrected formulation cataloged by Huband et
  al. [Huband2006](@cite).
- [Fliege–Drummond–Svaiter (FDS)](@ref): one scalable, three-objective problem
  introduced by J. Fliege, L. M. Graña Drummond, and B. F. Svaiter
  [FDS2009](@cite).
- [Fonseca–Fleming (FF)](@ref): one fixed-dimension problem from Carlos M.
  Fonseca and Peter J. Fleming [FF1995](@cite).
- [Hillermeier (Hil)](@ref): one unconstrained, fixed-dimension academic
  problem from C. Hillermeier [Hil2001](@cite).
- [Ikeda–Kita–Kobayashi (IKK)](@ref): one fixed-dimension problem from
  K. Ikeda, H. Kita, and S. Kobayashi [IKK2001](@cite).
- [Ishibuchi–Murata (IM)](@ref): one fixed-dimension problem from H. Ishibuchi
  and T. Murata [IM1998](@cite).
- [Jin–Olhofer–Sendhoff (JOS)](@ref): two variable-dimension problems from
  Yaochu Jin, Markus Olhofer, and Bernhard Sendhoff [JOS2001](@cite), using
  source-order numbering and documenting the alternative Huband catalog name.
- [Kim–de Weck (KW)](@ref): one fixed-dimension problem from the second
  numerical example of I. Y. Kim and O. L. de Weck [KW2005](@cite), expressed
  in the package's minimization convention.
- [Lis–Eiben (LE)](@ref): one fixed-dimension problem from Test 1 of J. Lis and
  A. E. Eiben [LE1997](@cite).
- [Lovison (Lov)](@ref): six fixed-dimension examples from Alberto Lovison
  [Lovison2011](@cite), including a smooth regularization of ZDT3
  [ZDT2000](@cite), with documented minimization conventions.
