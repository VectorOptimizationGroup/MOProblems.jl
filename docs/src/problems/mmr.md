# Miglierina–Molho–Recchioni (MMR)

This family comprises the `MMR1` through `MMR4` constructors. They implement,
in order, Tests 1–4 from “Box-constrained multi-objective optimization: A
gradient-like method without ‘a priori’ scalarization” [MMR2008](@cite).

## Overview

All four constructors have two objectives and fixed dimensions. Their bounds
are shown below.

| Problem | Source test | `nvar` | `nobj` | Lower bounds | Upper bounds |
|:---|---:|---:|---:|:---|:---|
| `MMR1` | 1 | 2 | 2 | `[0.1, 0.0]` | `[1.0, 1.0]` |
| `MMR2` | 2 | 2 | 2 | `[0.0, 0.0]` | `[1.0, 1.0]` |
| `MMR3` | 3 | 2 | 2 | `[-1.0, -1.0]` | `[1.0, 1.0]` |
| `MMR4` | 4 | 3 | 2 | `[0.0, 0.0, 0.0]` | `[4.0, 4.0, 4.0]` |

Analytical Jacobians are registered for all four constructors. Hessians are
not registered. The catalog metadata classifies every objective in `MMR1`
through `MMR4` as not strictly convex (`:not_strictly_convex`).

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructors. For each problem, let ``F:\mathbb{R}^n \to \mathbb{R}^2`` be
defined by ``F(x)=(f_1(x),f_2(x))``.

### MMR1

For ``x \in [0.1,1]\times[0,1]``, the objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= \frac{\psi(x_2)}{x_1},
\end{aligned}
```

where

```math
\psi(x_2) = 2
- 0.8\exp\left[-\left(\frac{x_2-0.6}{0.4}\right)^2\right]
- \exp\left[-\left(\frac{x_2-0.2}{0.04}\right)^2\right].
```

### MMR2

For ``x \in [0,1]^2``, the objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= \psi(x_2)r(x_1,x_2),
\end{aligned}
```

where

```math
\begin{aligned}
r(x_1,x_2)
&= 1-\left(\frac{x_1}{\psi(x_2)}\right)^\alpha
-\frac{x_1}{\psi(x_2)}\sin(2\pi q x_1),\\
\psi(x_2) &= 1+10x_2,\\
\alpha &= 2,\\
q &= 4.
\end{aligned}
```

### MMR3

For ``x \in [-1,1]^2``, the objectives are

```math
\begin{aligned}
f_1(x) &= x_1^3,\\
f_2(x) &= (x_2-x_1)^3.
\end{aligned}
```

### MMR4

For ``x \in [0,4]^3``, the objectives are

```math
\begin{aligned}
f_1(x) &= x_1-2x_2-x_3-\frac{36}{2x_1+x_2+2x_3+1},\\
f_2(x) &= -3x_1+x_2-x_3.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = MMR1()
x = [0.5, 0.2]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.MMR1
MOProblems.MMR2
MOProblems.MMR3
MOProblems.MMR4
```
