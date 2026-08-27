# Schütze–Laumanns–Coello Coello–Dellnitz–Talbi (SLCDT)

This family comprises `SLCDT1` and `SLCDT2`, from the numerical results of
Schütze, Laumanns, Coello Coello, Dellnitz, and Talbi [SLCDT2008](@cite).

## Overview

Both constructors have fixed dimensions and registered componentwise variable
bounds. `SLCDT1` takes a perturbation coefficient `λ`, which selects the
bounds; `SLCDT2` takes no parameters.

| Problem | `λ` | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|:---|---:|---:|---:|---:|
| `SLCDT1` | `0` | 2 | 2 | -0.5 | 0.5 |
| `SLCDT1` | any other value (default `0.85`) | 2 | 2 | -1.5 | 1.5 |
| `SLCDT2` | — | 10 | 3 | -1.0 | 1.0 |

The two rows for `SLCDT1` reproduce the two settings used in the source, which
pairs ``\lambda=0`` with the domain ``[-0.5,0.5]^2`` and ``\lambda=0.85`` with
``[-1.5,1.5]^2``.

Analytical Jacobians are registered for both constructors. Hessians are not
registered. The catalog metadata classifies every objective of `SLCDT1` and
`SLCDT2` as not strictly convex (`:not_strictly_convex`).

## Mathematical formulations

### SLCDT1

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x,y)=(f_1(x,y,\lambda),f_2(x,y,\lambda))``. The objectives are

```math
\begin{aligned}
f_1(x,y,\lambda) &= \frac{1}{2}\left(\sqrt{1+(x+y)^2}+\sqrt{1+(x-y)^2}+x-y\right)
                    + \lambda\,e^{-(x-y)^2},\\
f_2(x,y,\lambda) &= \frac{1}{2}\left(\sqrt{1+(x+y)^2}+\sqrt{1+(x-y)^2}-x+y\right)
                    + \lambda\,e^{-(x-y)^2}.
\end{aligned}
```

### SLCDT2

Let ``F:\mathbb{R}^{10} \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``. The objectives are

```math
f_i(x) = \sum_{\substack{j=1\\ j\neq i}}^{10}\left(x_j-a_j^i\right)^2
         + \left(x_i-a_i^i\right)^4,
\qquad i = 1,2,3,
```

where

```math
\begin{aligned}
a^1 &= (1,1,1,1,\ldots),\\
a^2 &= (-1,-1,-1,-1,\ldots),\\
a^3 &= (1,-1,1,-1,\ldots),
\end{aligned}
```

and ``a^1,a^2,a^3 \in \mathbb{R}^{10}``.

## Usage

```julia
using MOProblems

prob1 = SLCDT1()
x1 = [0.5, -0.5]

values1 = eval_f(prob1, x1)
J1 = eval_jacobian(prob1, x1)

prob1b = SLCDT1(λ = 0.0)

prob2 = SLCDT2()
x2 = fill(0.0, prob2.nvar)

values2 = eval_f(prob2, x2)
J2 = eval_jacobian(prob2, x2)
```

## Constructor reference

```@docs
MOProblems.SLCDT1
MOProblems.SLCDT2
```
