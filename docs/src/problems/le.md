# Lis–Eiben (LE)

This family is represented by the `LE1` constructor. It implements Test 1 from
J. Lis and A. E. Eiben's “A multi-sexual genetic algorithm for multiobjective
optimization” [LE1997](@cite).

## Overview

`LE1` has `nvar = 2` and `nobj = 2`. The componentwise bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `LE1` | 2 | 2 | -5.0 | 10.0 |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

!!! warning "Jacobian domain"
    Both objective values are defined throughout ``[-5,10]^2``. The first
    objective is not differentiable at ``(0,0)``, and the second is not
    differentiable at ``(0.5,0.5)``. Consequently, Jacobian row 1 throws a
    `DomainError` at ``(0,0)``, whereas row 2 throws a `DomainError` at
    ``(0.5,0.5)``. The other row remains available at each point through
    `eval_jacobian_row`.

    A full `eval_jacobian(prob, x)` call throws at either singular point. No
    positive tolerance is imposed: all other points are evaluated by the
    analytical formulas, subject to the range and precision of the input
    floating-point type.

## Mathematical formulation

The formulas below describe the objective functions implemented by the
constructor. Let ``F:[-5,10]^2\to\mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= \left(x_1^2+x_2^2\right)^{1/8},\\
f_2(x) &= \left((x_1-\tfrac{1}{2})^2
                    +(x_2-\tfrac{1}{2})^2\right)^{1/4}.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = LE1()
x = [0.25, 0.25]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.LE1
```
