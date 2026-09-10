# Ikeda–Kita–Kobayashi (IKK)

This family is represented by the `IKK1` constructor. The problem is drawn
from “Failure of Pareto-based MOEAs: does non-dominated really mean near to
optimal?” [IKK2001](@cite).

## Overview

`IKK1` has `nvar = 2` and `nobj = 3`. Its componentwise bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `IKK1` | 2 | 3 | -50.0 | 50.0 |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies all three objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^2 \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``, where
``x=(x_1,x_2) \in \mathbb{R}^2``. The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2,\\
f_2(x) &= (x_1-20)^2,\\
f_3(x) &= x_2^2.
\end{aligned}
```

## Usage

```jldoctest ikk_usage
julia> using MOProblems

julia> prob = IKK1();

julia> x = [0.0, 0.0];

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(3, (3, 2))
```

## Constructor reference

```@docs
MOProblems.IKK1
```
