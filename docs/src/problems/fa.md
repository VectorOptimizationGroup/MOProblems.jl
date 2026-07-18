# Farhang-Mehr-Azarm (FA)

This family is represented by the `FA1` constructor. The problem is drawn from
"Diversity assessment of Pareto optimal solution sets: an entropy approach"
[FA2002](@cite).

## Overview

The constructor has `nvar = 3` and `nobj = 3`. The componentwise bounds are
shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `FA1` | 3 | 3 | 0.0 | 1.0 |

Analytical Jacobians are registered for the constructor. **Hessians are not
registered**. The catalog metadata classifies all objectives in `FA1` as not
strictly convex (`:not_strictly_convex`).

Although the variable bounds include `x_1 = 0`, the analytical derivatives of
`f_2` and `f_3` with respect to `x_1` are singular at that boundary because the
implemented formulas contain powers of `f_1(x)` with exponents below one. The
objective values themselves remain defined at `x_1 = 0`.

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructor. Let ``F:\mathbb{R}^3 \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``, where
``x = (x_1,x_2,x_3) \in \mathbb{R}^3``.

### FA1

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1 - \exp(-4x_1)}{1 - \exp(-4)},\\
f_2(x) &= (x_2 + 1)\left(1 -
\left(\frac{f_1(x)}{x_2 + 1}\right)^{0.5}\right),\\
f_3(x) &= (x_3 + 1)\left(1 -
\left(\frac{f_1(x)}{x_3 + 1}\right)^{0.1}\right).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = FA1()
x = [0.5, 0.5, 0.5]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.FA1
```
