# Farina (Far)

This family is represented by the `Far1` constructor. The analytical test case
originates in "A neural network based generalized response surface
multiobjective evolutionary algorithm" [Far2002](@cite). The name `Far1`
and the corrected formulation implemented by MOProblems.jl follow the catalog
of Huband et al. [Huband2006](@cite).

!!! note "Source and transcription"
    Farina presents the analytical test case in Equation (4) but does not name
    it `Far1`. Huband et al. assign that catalog name and explicitly identify
    apparent typographical errors in the equation as printed, providing a
    corrected formulation in Table XVI. MOProblems.jl implements the Huband et
    al. formulation, not a literal transcription of Equation (4).

    In particular, the fourth exponential term of ``f_1`` is implemented as a
    bounded exponential centered at ``(0.6,-0.6)``, with the negative sum of
    the two squared offsets in its exponent. The fifth exponential term of
    ``f_2`` has a positive coefficient and likewise uses the negative sum of
    the squared offsets from ``(-0.4,-0.8)``. These are the two corrected terms
    reported by Huband et al. and used by the constructor.

## Overview

The constructor has `nvar = 2` and `nobj = 2`. It has no general constraints;
the componentwise variable bounds are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `Far1` | 2 | 2 | -1.0 | 1.0 |

An analytical Jacobian is registered. **Hessians are not registered**. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructor. Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``, where ``x=(x_1,x_2)\in[-1,1]^2``.

### Far1

The objectives are

```math
\begin{aligned}
f_1(x) ={}& -2\exp\left(15\left(-(x_1-0.1)^2-x_2^2\right)\right)\\
&-\exp\left(20\left(-(x_1-0.6)^2-(x_2-0.6)^2\right)\right)\\
&+\exp\left(20\left(-(x_1+0.6)^2-(x_2-0.6)^2\right)\right)\\
&+\exp\left(20\left(-(x_1-0.6)^2-(x_2+0.6)^2\right)\right)\\
&+\exp\left(20\left(-(x_1+0.6)^2-(x_2+0.6)^2\right)\right),\\[0.5em]
f_2(x) ={}& 2\exp\left(20\left(-x_1^2-x_2^2\right)\right)\\
&+\exp\left(20\left(-(x_1-0.4)^2-(x_2-0.6)^2\right)\right)\\
&-\exp\left(20\left(-(x_1+0.5)^2-(x_2-0.7)^2\right)\right)\\
&-\exp\left(20\left(-(x_1-0.5)^2-(x_2+0.7)^2\right)\right)\\
&+\exp\left(20\left(-(x_1+0.4)^2-(x_2+0.8)^2\right)\right).
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = Far1()
x = [0.0, 0.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.Far1
```
