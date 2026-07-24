# Kim–de Weck (KW)

This family is represented by the `KW2` constructor. It provides a
minimization-equivalent implementation of the second numerical example in
I. Y. Kim and O. L. de Weck's “Adaptive weighted-sum method for bi-objective
optimization: Pareto front generation” [KW2005](@cite).

!!! warning "Optimization convention"
    Kim and de Weck formulate Example 2 as the maximization of ``J(x)``.
    `KW2` instead minimizes ``F(x)=-J(x)``. This preserves the
    Pareto-optimal decision set, while objective values and the Pareto front in
    objective space are reflected through the origin. Values in the article's
    convention are obtained as `-eval_f(prob, x)`.

## Overview

`KW2` has `nvar = 2` and `nobj = 2`. Its componentwise variable bounds are
shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `KW2` | 2 | 2 | -3.0 | 3.0 |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be the implemented minimization vector,
``F(x)=(f_1(x),f_2(x))=-J(x)``, where
``x=(x_1,x_2)\in[-3,3]^2``. Its components are

```math
\begin{aligned}
f_1(x) ={}&
-3(1-x_1)^2\exp\left(-x_1^2-(x_2+1)^2\right)\\
&+10\left(\frac{x_1}{5}-x_1^3-x_2^5\right)
\exp\left(-x_1^2-x_2^2\right)\\
&+3\exp\left(-(x_1+2)^2-x_2^2\right)
-\frac{1}{2}(2x_1+x_2),\\
f_2(x) ={}&
-3(1+x_2)^2\exp\left(-x_2^2-(1-x_1)^2\right)\\
&+10\left(-\frac{x_2}{5}+x_2^3+x_1^5\right)
\exp\left(-x_1^2-x_2^2\right)\\
&+3\exp\left(-(2-x_2)^2-x_1^2\right).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = KW2()
x = [0.0, 0.0]

values = eval_f(prob, x)
article_values = -values
jac = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.KW2
```
