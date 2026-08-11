# Mao–Hirasawa–Hu–Murata (MHHM)

The `MHHM1` and `MHHM2` constructors implement the optimization problems used
in Simulations 1 and 2, respectively, by Jiangming Mao, K. Hirasawa, Jinlu Hu,
and J. Murata in “Genetic symbiosis algorithm for multiobjective optimization
problem” [MHHM2000](@cite).

## Overview

Both constructors have three objectives and componentwise variable bounds of
`[0, 1]`. Their fixed dimensions are shown below.

| Problem | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|
| `MHHM1` | 1 | 3 | 0.0 | 1.0 |
| `MHHM2` | 2 | 3 | 0.0 | 1.0 |

Analytical Jacobians are registered for both constructors. Hessians are not
registered. The catalog metadata classifies every objective in `MHHM1` and
`MHHM2` as strictly convex (`:strictly_convex`).

## Mathematical formulations

### MHHM1

Let ``F:[0,1]\to\mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= (x_1-0.8)^2,\\
f_2(x) &= (x_1-0.85)^2,\\
f_3(x) &= (x_1-0.9)^2.
\end{aligned}
```

### MHHM2

Let ``F:[0,1]^2\to\mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= (x_1-0.8)^2+(x_2-0.6)^2,\\
f_2(x) &= (x_1-0.85)^2+(x_2-0.7)^2,\\
f_3(x) &= (x_1-0.9)^2+(x_2-0.6)^2.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = MHHM2()
x = [0.85, 0.65]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.MHHM1
MOProblems.MHHM2
```
