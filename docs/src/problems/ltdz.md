# Laumanns–Thiele–Deb–Zitzler (LTDZ)

This family is represented by the canonical `LTDZ1` constructor. The test
problem originates in Equation (8) of “Combining Convergence and Diversity in
Evolutionary Multiobjective Optimization” by Laumanns, Thiele, Deb, and
Zitzler [Laumanns2002](@cite).

The public `LTDZ()` constructor is an alias for `LTDZ1()`. Fliege, Drummond,
and Svaiter refer to the benchmark as `LTDZ` [FDS2009](@cite), whereas Huband
et al. assign it the catalog name `LTDZ1` [Huband2006](@cite). MOProblems.jl
uses `LTDZ1` as the canonical catalog identity while supporting both
constructor names.

!!! note "Source transcription and optimization convention"
    Equation (8) of Laumanns et al. is formulated for maximization and prints
    ``f_3`` with ``\cos(\pi x_1/2)\sin(\pi x_1/2)``. Huband et al. classify
    `LTDZ1` as apparently containing a typographical error and list ``f_3``
    with only ``\sin(\pi x_1/2)`` in Table XVI. `LTDZ1` adopts the latter
    expression and negates the objectives for minimization.

## Overview

`LTDZ1` has `nvar = 3` and `nobj = 3`. The alias `LTDZ()` constructs the same
canonical problem and therefore also reports `prob.name == "LTDZ1"`.
Its componentwise bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `LTDZ1` | 3 | 3 | 0.0 | 1.0 |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies all three objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

The formulas below describe the minimization objectives implemented by both
constructors. Let ``F:\mathbb{R}^3\to\mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``, where
``x=(x_1,x_2,x_3)\in[0,1]^3``. The objectives are

```math
\begin{aligned}
f_1(x) &=
-3+(1+x_3)\cos\left(\frac{\pi x_1}{2}\right)
             \cos\left(\frac{\pi x_2}{2}\right),\\
f_2(x) &=
-3+(1+x_3)\cos\left(\frac{\pi x_1}{2}\right)
             \sin\left(\frac{\pi x_2}{2}\right),\\
f_3(x) &=
-3+(1+x_3)\sin\left(\frac{\pi x_1}{2}\right).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = LTDZ1()
x = [0.5, 0.5, 0.0]

values = eval_f(prob, x)
huband_maximization_values = -values
J = eval_jacobian(prob, x)

same_prob = LTDZ()
```

## Constructor reference

```@docs
MOProblems.LTDZ1
MOProblems.LTDZ
```
