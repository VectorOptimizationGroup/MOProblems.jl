# Quagliarella–Vicini (QV)

This family is represented by the `QV1` constructor. Quagliarella and Vicini
introduced the problem in "Sub-population policies for a parallel
multiobjective genetic algorithm with applications to wing design"
[QV1998](@cite). Huband et al. later reproduced the same formulation and
parameter domain under the `QV1` name [Huband2006](@cite).

## Overview

`QV1(n)` requires `n >= 1` and has `nvar = n` and `nobj = 2`. The default
`n = 16` is the dimension used by Quagliarella and Vicini. The constructor
retains the componentwise domain specified in both sources.

| Problem | Default `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `QV1` | 16 | 2 | -5.12 | 5.12 |

QV1 has no general equality or inequality constraints. An analytical Jacobian
is registered. **Hessians are not registered**. The catalog metadata classifies
both objectives as not strictly convex (`:not_strictly_convex`).

!!! warning "Jacobian at the individual objective minimizers"
    The first objective is not differentiable at ``x=(0,\ldots,0)``, and the
    second is not differentiable at ``x=(1.5,\ldots,1.5)``. The registered
    analytical Jacobian is therefore valid only away from these two points.

    Consequently, Jacobian row 1 throws a `DomainError` at ``(0,\ldots,0)``,
    whereas row 2 throws a `DomainError` at ``(1.5,\ldots,1.5)``. The other row
    remains available at each point through `eval_jacobian_row`.

    A full `eval_jacobian(prob, x)` call throws at either singular point. No
    positive tolerance is imposed: all other points are evaluated by the
    analytical formulas, subject to the range and precision of the input
    floating-point type.

## Mathematical formulation

Let ``F:[-5.12,5.12]^n\to\mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``n\geq1``. The objectives are

```math
\begin{aligned}
f_1(x) &= \left[\frac{1}{n}\sum_{i=1}^{n}
\left(x_i^2-10\cos(2\pi x_i)+10\right)\right]^{1/4},\\
f_2(x) &= \left[\frac{1}{n}\sum_{i=1}^{n}
\left((x_i-1.5)^2-10\cos(2\pi(x_i-1.5))+10\right)\right]^{1/4}.
\end{aligned}
```

Equivalently, both objectives are instances of the shifted expression

```math
f_k(x)=\left[\frac{1}{n}\sum_{i=1}^{n}
\left((x_i-a_k)^2-10\cos(2\pi(x_i-a_k))+10\right)\right]^{1/4},
\qquad a_1=0,\quad a_2=1.5.
```

## Usage

```julia
using MOProblems

prob = QV1()
x = fill(0.75, prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.QV1
```
