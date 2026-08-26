# Stadler–Dauer (SD)

This family is represented by the `SD` constructor. The problem is the “Elastic
Trusses” example of “Multicriteria Optimization in Engineering: A Tutorial and
Survey” [SD1992](@cite).

## Overview

`SD` has `nvar = 4` and `nobj = 2`. Its componentwise variable bounds are shown
below.

| Problem | `nvar` | `nobj` | Lower bounds | Upper bounds |
|:---|---:|---:|:---|:---|
| `SD` | 4 | 2 | ``[1, \sqrt{2}, \sqrt{2}, 1]`` | ``[3, 3, 3, 3]`` |

The lower bounds keep the feasible set inside the positive orthant, away from
the poles of ``f_2``.

An analytical Jacobian is registered. Hessians are not registered. The
catalog metadata classifies ``f_1`` as not strictly convex
(`:not_strictly_convex`) and ``f_2`` as strictly convex (`:strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^4 \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``,
where ``x = (x_1,x_2,x_3,x_4)``. The objectives are

```math
\begin{aligned}
f_1(x) &= 2x_1 + \sqrt{2}\,(x_2 + x_3) + x_4,\\
f_2(x) &= \frac{2}{x_1} + \frac{2\sqrt{2}}{x_2}
       + \frac{2\sqrt{2}}{x_3} + \frac{2}{x_4}.
\end{aligned}
```

## Source formulation

The source [SD1992](@cite) states the problem as the optimal design of the four-bar truss of
its Fig. 9, loaded by forces ``F``. The decision variables ``x_1,\ldots,x_4``
are the cross-sectional areas of the four bars, and the two criteria are the
volume of the truss and the deflection of its outermost joint,

```math
\begin{aligned}
g_1(x) &= L\left(2x_1 + \sqrt{2}\,x_2 + \sqrt{2}\,x_3 + x_4\right),\\
g_2(x) &= \frac{FL}{E}\left(\frac{2}{x_1} + \frac{2\sqrt{2}}{x_2}
       + \frac{2\sqrt{2}}{x_3} + \frac{2}{x_4}\right),
\end{aligned}
```

over the feasible set

```math
\begin{aligned}
\frac{F}{\sigma} \le\;& x_1 \le \frac{3F}{\sigma}, &
\sqrt{2}\,\frac{F}{\sigma} \le\;& x_2 \le \frac{3F}{\sigma},\\
\sqrt{2}\,\frac{F}{\sigma} \le\;& x_3 \le \frac{3F}{\sigma}, &
\frac{F}{\sigma} \le\;& x_4 \le \frac{3F}{\sigma},
\end{aligned}
```

where ``\sigma`` is a characteristic stress, ``E`` is the elastic modulus, ``L``
is the length of a truss section, and ``F`` is the applied force.

`SD` implements the normalized instance ``L = 1``, ``F/\sigma = 1``, and
``FL/E = 1``, so that ``f_1 = g_1`` and ``f_2 = g_2`` over the bounds tabulated
above. The physical parameters are not exposed as constructor arguments. They
would not produce a structurally different problem: writing ``s = F/\sigma`` and
substituting ``x = s\,y``,

```math
g_1(s\,y) = (L s)\, f_1(y),
\qquad
g_2(s\,y) = \left(\frac{L\sigma}{E}\right) f_2(y),
\qquad y \in [1,3]\times[\sqrt{2},3]^2\times[1,3],
```

so every choice of ``F``, ``\sigma``, ``E``, and ``L`` is the implemented
instance up to a positive scaling of the decision variables and a positive
scaling of each objective. Pareto dominance is invariant under positive
componentwise scaling of the objectives, so the Pareto-optimal set of the
parametric problem is ``s`` times the Pareto-optimal set of `SD`, and its
Pareto front is the front of `SD` with the first objective scaled by ``L s``
and the second by ``L\sigma/E``.

## Usage

```julia
using MOProblems

prob = SD()
x = [2.0, 2.0, 2.0, 2.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.SD
```
