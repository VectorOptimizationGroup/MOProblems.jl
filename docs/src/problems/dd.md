# Das–Dennis (DD)

The `DD1` constructor implements the numerical biobjective example from
Indraneel Das and J. E. Dennis, “Normal-Boundary Intersection: A New Method
for Generating the Pareto Surface in Nonlinear Multicriteria Optimization
Problems” [DD1998](@cite).

## Overview

`DD1` has five variables, two objectives, two equality constraints, and one
inequality constraint. It has no explicit variable bounds. The constraint
mapping follows the convention

```math
l_c \leq c(x) \leq u_c.
```

| Problem | `nvar` | `nobj` | `ncon_eq` | `ncon_ineq` | Variable bounds |
|:---|---:|---:|---:|---:|:---|
| `DD1` | 5 | 2 | 2 | 1 | none |

Analytical Jacobians and Hessians are registered for both objectives and all
constraints. The catalog metadata classifies the first objective as strictly
convex (`:strictly_convex`) and the second as not strictly convex
(`:not_strictly_convex`).

## Mathematical formulation

Let ``F:\mathbb{R}^5 \to \mathbb{R}^2`` be defined by
``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2+x_2^2+x_3^2+x_4^2+x_5^2,\\
f_2(x) &= 3x_1+2x_2-\frac{x_3}{3}+0.01(x_4-x_5)^3.
\end{aligned}
```

The traditional equality and inequality constraint functions are

```math
\begin{aligned}
h_1(x) &= x_1+2x_2-x_3-0.5x_4+x_5-2 = 0,\\
h_2(x) &= 4x_1-2x_2+0.8x_3+0.6x_4+0.5x_5^2 = 0,\\
g_1(x) &= x_1^2+x_2^2+x_3^2+x_4^2+x_5^2-10 \leq 0.
\end{aligned}
```

In the evaluation API, these functions are stored as

```math
c(x)=\begin{bmatrix}h_1(x) & h_2(x) & g_1(x)\end{bmatrix}^{\mathsf T},
\qquad
l_c=\begin{bmatrix}0&0&-\infty\end{bmatrix}^{\mathsf T},
\qquad
u_c=\begin{bmatrix}0&0&0\end{bmatrix}^{\mathsf T}.
```

## Usage

```julia
using MOProblems

prob = DD1()
x = [1 / 3, 0.0, -5 / 3, 0.0, 0.0]

objectives = eval_f(prob, x)
constraints = eval_c(prob, x)
objective_jacobian = eval_jacobian(prob, x)
constraint_jacobian = eval_constraint_jacobian(prob, x)
objective_hessians = eval_hessian(prob, x)
constraint_hessians = eval_constraint_hessian(prob, x)
```

The constraint values are interpreted together with `prob.lcon` and
`prob.ucon`.

## Constructor reference

```@docs
MOProblems.DD1
```
