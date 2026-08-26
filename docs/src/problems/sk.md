# Socha–Kisiel-Dorohinicki (SK)

This family is represented by the `SK1` and `SK2` constructors. Socha and
Kisiel-Dorohinicki used both problems as test cases in "Agent-based
evolutionary multiobjective optimisation" [SK2002](@cite). Huband et al. later
cataloged them under the `SK1` and `SK2` names in Table XVI
[Huband2006](@cite).

!!! warning "Optimization convention"
    Both problems are stated as maximization problems: Huband et al. list every
    objective of `SK1` and `SK2` with a `Max.` qualifier
    [Huband2006](@cite). MOProblems.jl follows its minimization convention by
    implementing the negative of each source objective. This preserves the
    Pareto-optimal decision set, while reflecting the Pareto front through the
    origin. Values in the source maximization convention are obtained as
    `-eval_f(prob, x)`.

!!! note "Corrected SK1 formulation"
    Huband et al. identify the second objective of `SK1` as containing a
    typographical error in [SK2002](@cite) and give the corrected formulation
    in Table XVI [Huband2006](@cite). `SK1` implements the corrected version.
    `SK2` requires no such correction.

## Overview

Both problems have fixed dimensions and are unconstrained.

| Problem | `nvar` | `nobj` | Registered bounds | Recommended working box |
|:---|---:|---:|:---|:---|
| `SK1` | 1 | 2 | None | ``[-100,100]`` |
| `SK2` | 4 | 2 | None | ``[-10,10]^4`` |

An analytical Jacobian is registered for both problems. Hessians are not
registered. The catalog metadata classifies both objectives of `SK1` as not
strictly convex (`:not_strictly_convex`); for `SK2` it classifies ``f_1`` as
strictly convex (`:strictly_convex`) and ``f_2`` as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulations

The formulas below describe the minimization objectives implemented by the
constructors, that is, the negatives of the corrected source objectives.

### SK1

Let ``F:\mathbb{R}\to\mathbb{R}^2`` be the implemented minimization vector
``F(x)=(f_1(x),f_2(x))``, where ``x = (x_1)``. Its components are the quartic
polynomials

```math
\begin{aligned}
f_1(x) &= x_1^4 + 3x_1^3 - 10x_1^2 - 10x_1 - 10,\\
f_2(x) &= 0.5\,x_1^4 - 2x_1^3 - 10x_1^2 + 10x_1 - 5.
\end{aligned}
```

### SK2

Let ``F:\mathbb{R}^4\to\mathbb{R}^2`` be the implemented minimization vector
``F(x)=(f_1(x),f_2(x))``, where ``x = (x_1,x_2,x_3,x_4)``. Its components are

```math
\begin{aligned}
f_1(x) &= (x_1-2)^2 + (x_2+3)^2 + (x_3-5)^2 + (x_4-4)^2 - 5,\\
f_2(x) &= -\frac{\sin(x_1)+\sin(x_2)+\sin(x_3)+\sin(x_4)}
              {1 + \dfrac{x_1^2+x_2^2+x_3^2+x_4^2}{100}}.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = SK1()
x = [1.0]                        # within the recommended working box

values = eval_f(prob, x)
source_values = -values          # values in the source maximization convention
J = eval_jacobian(prob, x)

prob2 = SK2()
y = [1.0, -1.0, 2.0, 2.0]        # within the recommended working box

values2 = eval_f(prob2, y)
J2 = eval_jacobian(prob2, y)
```

## Constructor reference

```@docs
MOProblems.SK1
MOProblems.SK2
```
