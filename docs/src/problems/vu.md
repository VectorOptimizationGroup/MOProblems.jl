# Valenzuela-Rendón–Uresti-Charre (VU)

This family is represented by the `VU1` and `VU2` constructors. The problems are
the two test problems of “A nongenerational genetic algorithm for multiobjective
optimization” [VU1997](@cite), in the explicit form cataloged under the same
names in Table XVI of Huband et al. [Huband2006](@cite), because the original
text does not state them in a directly verifiable form.

## Overview

`VU1` and `VU2` have `nvar = 2` and `nobj = 2`. Their componentwise variable
bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bounds | Upper bounds |
|:---|---:|---:|:---|:---|
| `VU1` | 2 | 2 | ``[-3, -3]`` | ``[3, 3]`` |
| `VU2` | 2 | 2 | ``[-3, -3]`` | ``[3, 3]`` |

An analytical Jacobian is registered for both problems. Hessians are not
registered. In `VU1`, the catalog metadata classifies ``f_1`` as not strictly
convex (`:not_strictly_convex`) and ``f_2`` as strictly convex
(`:strictly_convex`). In `VU2`, it classifies both objectives as not strictly
convex.

## Mathematical formulations

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``.

### VU1

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{x_1^2+x_2^2+1},\\
f_2(x) &= x_1^2+3x_2^2+1.
\end{aligned}
```

### VU2

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1+x_2+1,\\
f_2(x) &= x_1^2+2x_2-1.
\end{aligned}
```

## Usage

```jldoctest vu_usage
julia> using MOProblems

julia> prob = VU1();

julia> x = [1.0, -2.0];

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(2, (2, 2))
```

## Constructor reference

```@docs
MOProblems.VU1
MOProblems.VU2
```
