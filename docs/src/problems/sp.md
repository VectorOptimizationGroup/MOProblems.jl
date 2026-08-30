# Sefrioui–Perlaux (SP)

This family is represented by the `SP1` constructor. It implements the simple
mathematical example introduced in Section 2.4 of “Nash genetic algorithms:
examples and applications” [SP2000](@cite).

## Overview

`SP1` has fixed dimensions and is unconstrained.

| Problem | `nvar` | `nobj` | Registered bounds | Recommended working box |
|:---|---:|---:|:---|:---|
| `SP1` | 2 | 2 | None | ``[-100,100]^2`` |

The source presents the objective functions without specifying a domain or a
finite search box. Accordingly, `SP1` does not register variable bounds. The
box ``[-100,100]^2`` is recommended only as a practical finite search region
when an algorithm requires one; it is not part of the problem definition.

An analytical Jacobian is registered. Hessians are not registered. The
catalog metadata classifies both objectives as strictly convex
(`:strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``x=(x_1,x_2)``. The constructor implements

```math
\begin{aligned}
f_1(x) &= (x_1-1)^2+(x_1-x_2)^2,\\
f_2(x) &= (x_2-3)^2+(x_1-x_2)^2.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = SP1()
x = [5 / 3, 7 / 3]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.SP1
```
