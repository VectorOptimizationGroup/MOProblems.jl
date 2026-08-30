# Shim–Suh–Furukawa–Yagawa–Yoshimura (SSFYY)

This family is represented by the `SSFYY2` constructor. It implements Test
problem 2, Equation (24), from “Pareto‐based continuous evolutionary algorithms
for multiobjective optimization” [SSFYY2002](@cite). The package currently
provides no constructors for the paper's other test problems.

## Overview

`SSFYY2` has fixed dimensions and is unconstrained.

| Problem | Source test | `nvar` | `nobj` | Registered bounds | Recommended initialization box |
|:---|---:|---:|---:|:---|:---|
| `SSFYY2` | 2 | 1 | 2 | None | ``[-100,100]`` |

The source says that the variable is initialized in ``[-100,100]`` for its
numerical experiment; it does not state this interval as a feasibility
constraint. Accordingly, `SSFYY2` does not register variable bounds. The same
interval is recommended when reproducing the source's initialization setup.

An analytical Jacobian is registered. Hessians are not registered. The
catalog metadata classifies ``f_1`` as not strictly convex
(`:not_strictly_convex`) and ``f_2`` as strictly convex
(`:strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}\to\mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``x=(x_1)``. The constructor implements

```math
\begin{aligned}
f_1(x) &= 10+x_1^2-10\cos\left(\frac{\pi x_1}{2}\right),\\
f_2(x) &= (x_1-4)^2.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = SSFYY2()
x = [1.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.SSFYY2
```
