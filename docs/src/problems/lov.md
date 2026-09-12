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

All constructors have two objectives, fixed dimensions, and analytical
Jacobians. Objective Hessians are not registered.

| Problem | `nvar` | Registered bounds | Recommended working box | Strictly convex objectives |
|:---|---:|:---|:---|:---|
| `Lov1` | 2 | none | ``[-10,10]^2`` | ``f_1``, ``f_2`` |
| `Lov2` | 2 | none | ``[-0.75,0.75]^2`` | none |
| `Lov3` | 2 | none | ``[-1,1]^2`` | ``f_1`` |
| `Lov4` | 2 | none | ``[-20,20]^2`` | ``f_2`` |
| `Lov5` | 3 | none | ``[-2,2]^3`` | none |
| `Lov6` | 6 | ``x_1\in[0.1,0.425]``; ``x_i\in[-0.16,0.16]``, ``i=2,\ldots,6`` | registered bounds | none |

For `Lov1` through `Lov5`, the returned boxes are recommendations of the
package developers, not constraints in the problem definitions. They do not
imply containment of the Pareto set.

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

```jldoctest lov_usage
julia> using MOProblems

julia> using Random

julia> prob = Lov5();

julia> lower, upper = recommended_bounds(prob);

julia> rng = MersenneTwister(1234);

julia> α = rand(rng, prob.nvar);

julia> x = lower .+ α .* (upper .- lower);

julia> @assert isnothing(prob.bounds)

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(2, (2, 3))
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
