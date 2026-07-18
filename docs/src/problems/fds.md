# Fliege–Drummond–Svaiter (FDS)

This family is represented by the `FDS` constructor. The scalable test problem
was introduced in "Newton's Method for Multiobjective Optimization"
[FDS2009](@cite).

## Overview

`FDS(n)` requires `n >= 1` and has `nvar = n` and `nobj = 3`; the default is
`n = 5`. Its componentwise bounds are shown below.

| Problem | `n` | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|---:|
| `FDS` | 5 | 5 | 3 | -2.0 | 2.0 |

The objective functions in equations (8.2)–(8.4) of Fliege, Drummond, and
Svaiter are presented without explicit variable bounds. In their numerical
experiments, the authors sampled starting points from ``[-2,2]^n`` and used the
same interval as box constraints. The `FDS` constructor follows this experimental
specification.

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies all three objectives as strictly convex
(`:strictly_convex`).

## Mathematical formulation

The formulas below describe the objective functions implemented by the
constructor. Let ``F:\mathbb{R}^n \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``, where ``n \geq 1`` and
``x=(x_1,\ldots,x_n)\in[-2,2]^n``. The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{n^2}\sum_{i=1}^{n} i(x_i-i)^4,\\
f_2(x) &= \exp\left(\frac{1}{n}\sum_{i=1}^{n}x_i\right)
         + \lVert x\rVert_2^2,\\
f_3(x) &= \frac{1}{n(n+1)}\sum_{i=1}^{n}
          i(n-i+1)\exp(-x_i).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = FDS()
x = zeros(5)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.FDS
```
