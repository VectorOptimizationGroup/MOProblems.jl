# Dumitrescu-Grosan-Oltean (DGO)

This family comprises the `DGO0`, `DGO1`, and `DGO2` constructors. The problems
are drawn from "A New Evolutionary Approach for Multiobjective Optimization"
[DGO2000](@cite).

The names `DGO1` and `DGO2` are common in later benchmark collections, but they
correspond to Examples 2 and 3 in the original paper. `DGO0` corresponds to
Example 1.

## Overview

All three constructors have `nvar = 1` and `nobj = 2`. Their componentwise
bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `DGO0` | 1 | 2 | -4.0 | 6.0 |
| `DGO1` | 1 | 2 | -10.0 | 13.0 |
| `DGO2` | 1 | 2 | -9.0 | 9.0 |

Analytical Jacobians are registered for all three constructors. **Hessians are
not registered**. The catalog metadata classifies both objectives in `DGO0` and
`DGO2` as strictly convex (`:strictly_convex`) and both objectives in `DGO1` as
not strictly convex (`:not_strictly_convex`).

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructors. For each problem, let ``F:\mathbb{R}^1 \to \mathbb{R}^2`` be
defined by ``F(x)=(f_1(x),f_2(x))``.

### DGO0

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2,\\
f_2(x) &= (x_1 - 2)^2.
\end{aligned}
```

### DGO1

The objectives are

```math
\begin{aligned}
f_1(x) &= \sin(x_1),\\
f_2(x) &= \sin(x_1 + 0.7).
\end{aligned}
```

### DGO2

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2,\\
f_2(x) &= 9 - \sqrt{81 - x_1^2}.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = DGO0()
x = [0.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.DGO0
MOProblems.DGO1
MOProblems.DGO2
```
