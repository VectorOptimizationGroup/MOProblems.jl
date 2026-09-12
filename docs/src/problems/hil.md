# Hillermeier (Hil)

This family is represented by the `Hil1` constructor. It implements the
academic example presented as Example 4.1 in C. Hillermeier's “Generalized
Homotopy Approach to Multiobjective Optimization” [Hil2001](@cite).

## Overview

`Hil1` has `nvar = 2` and `nobj = 2`. It has no registered variable bounds.

| Problem | `nvar` | `nobj` | Registered bounds | Recommended working box |
|:---|---:|---:|:---|:---|
| `Hil1` | 2 | 2 | none | ``[0,1]^2`` |

The source problem is defined for ``x \in \mathbb{R}^2``. Both objectives are
1-periodic in each variable, so the square ``[0,1]^2`` covers one complete
period in each variable and is sufficient to represent the full image set
``F(\mathbb{R}^2)``. [`recommended_bounds`](@ref) returns this square; it is a
sampling window, not a variable-bound specification.

An analytical Jacobian is registered. Hessians are not registered. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= \cos(a(x))b(x),\\
f_2(x) &= \sin(a(x))b(x),
\end{aligned}
```

where

```math
\begin{aligned}
a(x) &= \frac{2\pi}{360}\left(45
        +40\sin(2\pi x_1)+25\sin(2\pi x_2)\right),\\
b(x) &= 1+0.5\cos(2\pi x_1).
\end{aligned}
```

## Usage

```jldoctest hil_usage
julia> using MOProblems

julia> using Random

julia> prob = Hil1();

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
MOProblems.Hil1
```
