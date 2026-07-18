# Fonseca–Fleming (FF)

This family is represented by the `FF1` constructor. The test problem is
presented in "An Overview of Evolutionary Algorithms in Multiobjective
Optimization" [FF1995](@cite).

## Overview

`FF1` has `nvar = 2` and `nobj = 2`. It has no explicit variable bounds.

| Problem | `nvar` | `nobj` | Variable bounds |
|:---|---:|---:|:---|
| `FF1` | 2 | 2 | none |

Fonseca and Fleming present the objective functions without explicit variable
bounds. The `FF1` constructor follows that formulation.

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

The formulas below describe the objective functions implemented by the
constructor. Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``x=(x_1,x_2)\in\mathbb{R}^2``. The objectives
are

```math
\begin{aligned}
f_1(x) &= 1-\exp\left(-(x_1-1)^2-(x_2+1)^2\right),\\
f_2(x) &= 1-\exp\left(-(x_1+1)^2-(x_2-1)^2\right).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = FF1()
x = [0.0, 0.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.FF1
```
