# Ansary–Panda (AP)

This family comprises the `AP1`, `AP2`, `AP3`, and `AP4` constructors. All four
problems are drawn from “A modified Quasi-Newton method for vector optimization
problem” [AP2014](@cite).

## Overview

The table below shows the default dimensions and componentwise variable bounds
for each constructor.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `AP1` | 2 | 3 | -10.0 | 10.0 |
| `AP2` | 1 | 2 | -100.0 | 100.0 |
| `AP3` | 2 | 2 | -100.0 | 100.0 |
| `AP4` | 3 | 3 | -10.0 | 10.0 |

Analytical Jacobians and Hessians are registered for all four constructors.
The catalog metadata classifies the strict convexity of the objective functions
as follows:
- `AP1`: `[:not_strictly_convex, :strictly_convex, :strictly_convex]`
- `AP2`: `[:strictly_convex, :strictly_convex]`
- `AP3`: `[:not_strictly_convex, :not_strictly_convex]`
- `AP4`: `[:not_strictly_convex, :strictly_convex, :strictly_convex]`

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructors. For each problem, let ``F:\mathbb{R}^n \to \mathbb{R}^m`` be
defined by ``F(x)=(f_1(x),\ldots,f_m(x))``.

### AP1

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{4} \left( (x_1 - 1)^4 + 2(x_2 - 2)^4 \right), \\
f_2(x) &= \exp\left( \frac{x_1 + x_2}{2} \right) + x_1^2 + x_2^2, \\
f_3(x) &= \frac{1}{6} \left( \exp(-x_1) + 2\exp(-x_2) \right).
\end{aligned}
```

where ``x = (x_1, x_2) \in \mathbb{R}^2``.

### AP2

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2 - 4, \\
f_2(x) &= (x_1 - 1)^2.
\end{aligned}
```

where ``x \in \mathbb{R}^1``.

### AP3

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{4} \left( (x_1 - 1)^4 + 2(x_2 - 2)^4 \right), \\
f_2(x) &= (x_2 - x_1^2)^2 + (1 - x_1)^2.
\end{aligned}
```

where ``x = (x_1, x_2) \in \mathbb{R}^2``.

### AP4

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{9} \left( (x_1 - 1)^4 + 2(x_2 - 2)^4 + 3(x_3 - 3)^4 \right), \\
f_2(x) &= \exp\left( \frac{x_1 + x_2 + x_3}{3} \right) + x_1^2 + x_2^2 + x_3^2, \\
f_3(x) &= \frac{1}{12} \left( 3\exp(-x_1) + 4\exp(-x_2) + 3\exp(-x_3) \right).
\end{aligned}
```

where ``x = (x_1, x_2, x_3) \in \mathbb{R}^3``.

## Usage

```julia
using MOProblems

prob = AP1()
x = [0.0, 0.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
H = eval_hessian(prob, x)
```

## Constructor reference

```@docs
MOProblems.AP1
MOProblems.AP2
MOProblems.AP3
MOProblems.AP4
```
