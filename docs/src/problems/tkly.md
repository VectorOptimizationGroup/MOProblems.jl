# Tan–Khor–Lee–Yang (TKLY)

This family is represented by the `TKLY1` constructor. It implements Test
problem 2, Equations (12a)–(12e), from “A Tabu-Based Exploratory Evolutionary
Algorithm for Multiobjective Optimization” [TKLY2003](@cite). The package
currently provides no constructors for the paper's other test problems.

## Overview

`TKLY1` has `nvar = 4` and `nobj = 2`. Its componentwise variable bounds are
shown below.

| Problem | `nvar` | `nobj` | Lower bounds | Upper bounds |
|:---|---:|---:|:---|:---|
| `TKLY1` | 4 | 2 | ``[0.1, 0, 0, 0]`` | ``[1, 1, 1, 1]`` |


An analytical Jacobian is registered. Hessians are not registered. The
catalog metadata classifies both objectives as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^4 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The constructor
implements

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= \frac{1}{x_1}\prod_{i=1}^{3} g(x_{i+1}),
\end{aligned}
```

where ``g:\mathbb{R}\to\mathbb{R}`` is given by

```math
g(z) = 2 - \exp\left[-\left(\frac{z-0.1}{0.004}\right)^{2}\right]
         - 0.8\exp\left[-\left(\frac{z-0.9}{0.4}\right)^{2}\right].
```

## Usage

```julia
using MOProblems

prob = TKLY1()
x = [0.5, 0.1, 0.5, 0.9]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.TKLY1
```
