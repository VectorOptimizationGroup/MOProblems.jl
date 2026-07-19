# Ishibuchi–Murata (IM)

This family is represented by the `IM1` constructor. The problem is drawn from
“A multi-objective genetic local search algorithm and its application to
flowshop scheduling” [IM1998](@cite).

## Overview

`IM1` has `nvar = 2` and `nobj = 2`. Its componentwise bounds are shown below.

| Problem | `nvar` | `nobj` | ``x_1`` bounds | ``x_2`` bounds |
|:---|---:|---:|:---:|:---:|
| `IM1` | 2 | 2 | ``[1.0,4.0]`` | ``[1.0,2.0]`` |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``x=(x_1,x_2) \in \mathbb{R}^2``. The
objectives are

```math
\begin{aligned}
f_1(x) &= 2\sqrt{x_1},\\
f_2(x) &= x_1(1-x_2)+5.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = IM1()
x = [1.0, 1.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.IM1
```
