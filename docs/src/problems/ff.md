# Fonseca–Fleming (FF)

This family is represented by the `FF1` constructor. The test problem is
presented in "An Overview of Evolutionary Algorithms in Multiobjective
Optimization" [FF1995](@cite).

## Overview

`FF1` has `nvar = 2` and `nobj = 2`. It has no explicit variable bounds.

| Problem | `nvar` | `nobj` | Registered bounds | Recommended working box |
|:---|---:|---:|:---|:---|
| `FF1` | 2 | 2 | none | ``[-1,1]^2`` |

Fonseca and Fleming present the objective functions without explicit variable
bounds, and the `FF1` constructor follows that formulation. For experiments
that need a bounded region, [`recommended_bounds`](@ref) returns ``[-1,1]^2``,
a box recommended by the package developers; `prob.bounds` remains `nothing`.

An analytical Jacobian is registered. Hessians are not registered. The
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

```jldoctest ff_usage
julia> using MOProblems

julia> using Random

julia> prob = FF1();

julia> lower, upper = recommended_bounds(prob);

julia> rng = MersenneTwister(1234);

julia> α = rand(rng, prob.nvar);

julia> x = lower .+ α .* (upper .- lower);

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(2, (2, 2))
```

## Constructor reference

```@docs
MOProblems.FF1
```
