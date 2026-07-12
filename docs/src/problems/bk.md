# Binh–Korn (BK)

This family is represented by the `BK1` constructor. The problem is drawn from
“An evolution strategy for the multiobjective optimization” [BK1996](@cite).

## Overview

The constructor has `nvar = 2` and `nobj = 2`. The componentwise bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `BK1` | 2 | 2 | -5.0 | 10.0 |

Analytical Jacobians are registered for the constructor. **Hessians are not registered**. The catalog metadata classifies both objectives in `BK1` as strictly convex (`:strictly_convex`).

## Mathematical formulations

The formulas below describe the objective functions implemented by the constructor. Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``, where ``x = (x_1,x_2) \in \mathbb{R}^2``.

### BK1

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2 + x_2^2,\\
f_2(x) &= (x_1 - 5)^2 + (x_2 - 5)^2.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = BK1()
x = [0.0, 0.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.BK1
```
