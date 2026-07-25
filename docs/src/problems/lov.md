# Lovison (Lov)

This family comprises `Lov1` through `Lov6`, corresponding to Examples 1–6 in
Alberto Lovison's “Singular Continuation: Generating Piecewise Linear
Approximations to Pareto Sets via Global Analysis” [Lovison2011](@cite).
`Lov6` is Lovison's smooth regularization of the third ZDT problem introduced
by Zitzler, Deb, and Thiele [ZDT2000](@cite).

!!! warning "Optimization conventions"
    Lovison formulates Pareto optimality as maximization. `Lov1` through
    `Lov5` convert Examples 1–5 to the package's minimization convention by
    implementing the negatives of the article's utilities.

    `Lov6` is intentionally not negated. Lovison constructs Example 6 as a
    smooth regularization of the minimization problem ZDT3 and describes the
    corresponding critical branches as minima that are unstable in his
    maximization formalism. Keeping Equation (4.6) [Lovison2011](@cite) unchanged preserves its
    correspondence with ZDT3 [ZDT2000](@cite).

## Overview

All six constructors have fixed dimensions, two objectives, and registered
analytical Jacobians. `Lov1` through `Lov5` have no registered variable bounds.
`Lov6` retains the bounds that are part of Equation (4.6). **Hessians are not
registered.**

| Problem | `nvar` | `nobj` | Registered bounds |
|:---|---:|---:|:---|
| `Lov1` | 2 | 2 | none |
| `Lov2` | 2 | 2 | none |
| `Lov3` | 2 | 2 | none |
| `Lov4` | 2 | 2 | none |
| `Lov5` | 3 | 2 | none |
| `Lov6` | 6 | 2 | ``x_1\in[0.1,0.425]``; ``x_2,\ldots,x_6\in[-0.16,0.16]`` |

The catalog strict-convexity classifications are:

| Problem | ``f_1`` | ``f_2`` |
|:---|:---|:---|
| `Lov1` | strictly convex | strictly convex |
| `Lov2` | not strictly convex | not strictly convex |
| `Lov3` | strictly convex | not strictly convex |
| `Lov4` | not strictly convex | strictly convex |
| `Lov5` | not strictly convex | not strictly convex |
| `Lov6` | not strictly convex | not strictly convex |

### Suggested experimental boxes

Examples 1–5 do not include box constraints in the source formulation, and
the implementation does not apply the intervals below. They are retained only
as suggested finite regions for numerical experiments:

| Problem | Suggested lower value | Suggested upper value |
|:---|---:|---:|
| `Lov1` | -10.0 | 10.0 |
| `Lov2` | -0.75 | 0.75 |
| `Lov3` | -1.0 | 1.0 |
| `Lov4` | -20.0 | 20.0 |
| `Lov5` | -2.0 | 2.0 |

Each interval applies componentwise. These boxes are practical exploration
windows, not part of the mathematical definitions and not claims about the
location of complete Pareto sets. Lovison discusses multiple or local branches
in some individual examples, but does not state a general repetition property
for Pareto structures outside these boxes [Lovison2011](@cite).

## Mathematical formulations

The formulas below describe the minimization objectives implemented by the
constructors.

### Lov1

For ``x=(x_1,x_2)\in\mathbb{R}^2``,

```math
\begin{aligned}
f_1(x) &= 1.05x_1^2+0.98x_2^2,\\
f_2(x) &= 0.99(x_1-3)^2+1.03(x_2-2.5)^2.
\end{aligned}
```

### Lov2

For ``x=(x_1,x_2)\in\mathbb{R}^2`` with ``x_1\ne-1``,

```math
\begin{aligned}
f_1(x) &= x_2,\\
f_2(x) &= -\frac{x_2-x_1^3}{x_1+1}.
\end{aligned}
```

### Lov3

For ``x=(x_1,x_2)\in\mathbb{R}^2``,

```math
\begin{aligned}
f_1(x) &= x_1^2+x_2^2,\\
f_2(x) &= (x_1-6)^2-(x_2+0.3)^2.
\end{aligned}
```

### Lov4

For ``x=(x_1,x_2)\in\mathbb{R}^2``,

```math
\begin{aligned}
f_1(x)={}&x_1^2+x_2^2\\
&+4\left[
\exp\left(-(x_1+2)^2-x_2^2\right)
+\exp\left(-(x_1-2)^2-x_2^2\right)
\right],\\
f_2(x)={}&(x_1-6)^2+(x_2+0.5)^2.
\end{aligned}
```

### Lov5

For ``x=(x_1,x_2,x_3)\in\mathbb{R}^3``, let

```math
p_0=
\begin{pmatrix}
0\\
0.15\\
0
\end{pmatrix},
\qquad
p_1=
\begin{pmatrix}
0\\
-1.1\\
0
\end{pmatrix}.
```

Define

```math
M=
\begin{pmatrix}
-1.0 & -0.03 & 0.011\\
-0.03 & -1.0 & 0.07\\
0.011 & 0.07 & -1.01
\end{pmatrix}.
```

The auxiliary function in Equation (4.5) is

```math
g(x_1,x_2,x_3;M,p,\sigma)
=
\sqrt{\frac{2\pi}{\sigma}}
\exp\left(
\frac{
\left(
\begin{pmatrix}
x_1\\
x_2\\
x_3
\end{pmatrix}
-p
\right)^\top
M
\left(
\begin{pmatrix}
x_1\\
x_2\\
x_3
\end{pmatrix}
-p
\right)
}{\sigma^2}
\right).
```

Using `h` for the function denoted by ``f`` in the article, define

```math
h(x_1,x_2,x_3)
=
g(x_1,x_2,x_3;M,p_0,0.35)
+g(x_1,x_2,0.5x_3;M,p_1,3.0).
```

Lovison writes the two objectives of Example 5 for maximization. The
implementation negates them to follow the package's minimization convention:

```math
\begin{aligned}
f_1(x_1,x_2,x_3)
&=-\frac{\sqrt{2}}{2}x_1
  -\frac{\sqrt{2}}{2}h(x_1,x_2,x_3),\\
f_2(x_1,x_2,x_3)
&=\frac{\sqrt{2}}{2}x_1
  -\frac{\sqrt{2}}{2}h(x_1,x_2,x_3).
\end{aligned}
```

### Lov6

For ``x_1\in[0.1,0.425]`` and ``x_i\in[-0.16,0.16]`` for
``i=2,\ldots,6``,

```math
\begin{aligned}
f_1(x)&=x_1,\\
f_2(x)&=1-\sqrt{x_1}-x_1\sin(10\pi x_1)
        +\sum_{i=2}^{6}x_i^2.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = Lov5()
x = zeros(prob.nvar)

@assert isnothing(prob.bounds)
values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.Lov1
MOProblems.Lov2
MOProblems.Lov3
MOProblems.Lov4
MOProblems.Lov5
MOProblems.Lov6
```
