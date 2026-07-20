# Jin–Olhofer–Sendhoff (JOS)

This family exposes the first and fourth test functions from "Dynamic Weighted
Aggregation for Evolutionary Multi-Objective Optimization: Why Does It Work and
How?" by Jin, Olhofer, and Sendhoff [JOS2001](@cite).

!!! note "Naming convention"
    The source denotes its five test functions by ``F_1,\ldots,F_5`` rather
    than assigning `JOS` names. MOProblems.jl uses `JOS1` and `JOS4` so that
    the numeric suffix preserves the function number in the source, following
    the author-initial/source-order convention described by Fliege, Drummond,
    and Svaiter [FDS2009](@cite).

    Huband et al. retain these same two formulations but assign them the
    catalog-local names `JOS1` and `JOS2` [Huband2006](@cite). Consequently,
    `JOS4` in MOProblems.jl is the problem called `JOS2` in that review. The
    source's ``F_2``, ``F_3``, and ``F_5`` formulations are available from
    MOProblems.jl as `ZDT1`, `ZDT2`, and `ZDT3`, respectively
    [ZDT2000](@cite).

## Overview

Both constructors have `n` variables and two objectives. `JOS1` requires
`n >= 1`, whereas `JOS4` requires `n >= 2`. The default dimension of 50 matches
the dimension used for the `JOS1a` and `JOS4a` experiment instances reported
by Fliege, Drummond, and Svaiter [FDS2009](@cite). Both constructors retain the
componentwise domain ``[0,1]^n`` specified for the source test functions
[JOS2001](@cite). Fliege, Drummond, and Svaiter deliberately used alternative
box bounds in order to investigate the effects of different starting points
in their numerical experiments [FDS2009](@cite). Those experimental boxes are
not part of the constructors defined here.

| Problem | Default `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `JOS1` | 50 | 2 | 0.0 | 1.0 |
| `JOS4` | 50 | 2 | 0.0 | 1.0 |

Both problems have componentwise bounds ``[0,1]^n``. Neither problem has
general equality or inequality constraints.

Analytical Jacobians are registered for both constructors. **Hessians are not
registered**. The catalog metadata classifies both `JOS1` objectives as
strictly convex (`:strictly_convex`) and both `JOS4` objectives as not strictly
convex (`:not_strictly_convex`).

!!! warning "JOS4 Jacobian at the lower boundary"
    Both `JOS4` objective values are defined at ``x_1=0``. The derivative of
    ``f_2`` with respect to ``x_1`` is singular there because it contains
    ``\left(x_1/g(x)\right)^{-3/4}``. Consequently,
    `eval_jacobian(prob, x)` and Jacobian row 2 throw a `DomainError` when
    ``x_1=0``. The first Jacobian row remains available there through
    `eval_jacobian_row(prob, x, 1)`.

    No positive tolerance is imposed: positive values of ``x_1`` are evaluated
    by the analytical formula, subject to the range and precision of the input
    floating-point type.

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructors.

### JOS1

Let ``F:[0,1]^n\to\mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{n}\sum_{i=1}^{n}x_i^2,\\
f_2(x) &= \frac{1}{n}\sum_{i=1}^{n}(x_i-2)^2.
\end{aligned}
```

### JOS4

Let ``F:[0,1]^n\to\mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left[1-\left(\frac{x_1}{g(x)}\right)^{1/4}
                    -\left(\frac{x_1}{g(x)}\right)^4\right],
\end{aligned}
```

where

```math
g(x)=1+\frac{9}{n-1}\sum_{i=2}^{n}x_i.
```

## Usage

```julia
using MOProblems

prob = JOS4(n = 50)
x = fill(0.5, prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.JOS1
MOProblems.JOS4
```
