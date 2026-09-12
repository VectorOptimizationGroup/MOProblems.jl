# Moré–Garbow–Hillstrom (MGH)

The `MGH` names retain the numbering of four problems in the nonlinear
least-squares collection of Moré, Garbow, and Hillstrom [MGH1981](@cite). In
that source, the numbered functions are residuals, and the corresponding scalar
unconstrained objective is their sum of squares. Mita, Fukuda, and Yamashita
[Mita2019](@cite) report multiobjective formulations based on these problems in
Appendix A of their numerical study. Let `r_i` denote a residual from the
original collection. The formulations in [Mita2019](@cite) use `f_i = r_i` for
`MGH9` and `MGH16`, and `f_i = r_i^2` for `MGH26` and `MGH33`. The original
problems are unconstrained [MGH1981](@cite), while the bounds adopted by the
constructors are based on those reported in [Mita2019](@cite). The objectives
in MOProblems.jl follow these formulations, while the package makes documented
changes to some dimensions. Thus, the `MGH` prefix records
the historical origin and does not mean that every constructor literally
reproduces either source.

## Overview

The four constructors differ in whether the numbers of variables and objectives
are fixed, coupled, or independently configurable.

`MGH9` has fixed dimensions: the package exposes no dimension parameter and
constructs a problem with `nvar = 3` and `nobj = 15`. These dimensions agree
with both [MGH1981](@cite) and [Mita2019](@cite).

`MGH16` fixes `nvar = 4` and accepts `nobj >= 4`; its default is
`nobj = 5`. The original problem fixes four variables and allows at least four
objectives [MGH1981](@cite), while [Mita2019](@cite) uses the same package
defaults.

`MGH26` accepts `nvar >= 1` and couples the dimensions as
`nobj = nvar`; its default is `nvar = 4`. The original problem
[MGH1981](@cite) permits a
variable number of variables and couples the number of objectives to it, while [Mita2019](@cite) uses `nvar = nobj = 4`.

`MGH33` accepts `nvar >= 2` and `nobj >= 2` independently; its defaults are
`nvar = nobj = 10`. The original problem [MGH1981](@cite) permits a variable number of
variables but requires at least as many objectives, while
[Mita2019](@cite) uses `nvar = 10` and `nobj = 4`. Thus, the package supports
the dimensions independently.

The following table summarizes the dimension behavior implemented by the
constructors.

| Problem | Dimension behavior | Configurable parameters | Default `nvar` | Default `nobj` |
|:---|:---|:---|---:|---:|
| `MGH9`  | Fixed | — | 3 | 15 |
| `MGH16` | Fixed `nvar`, variable `nobj` | `nobj >= 4` | 4 | 5 |
| `MGH26` | Coupled | `nvar >= 1`, with `nobj = nvar` | 4 | 4 |
| `MGH33` | Independent | `nvar >= 2`, `nobj >= 2` | 10 | 10 |

Analytical Jacobians are registered for all four constructors. Hessians are
not registered. The catalog metadata classifies every objective in each
default instance as not strictly convex (`:not_strictly_convex`).


## Mathematical formulations

The formulas below reproduce the objectives implemented by the constructors.

### MGH9 — Gaussian

Let ``F:\mathbb{R}^3\to\mathbb{R}^{15}`` be defined by
``F(x)=(f_1(x),\ldots,f_{15}(x))`` for ``x\in[-2,2]^3``. The objectives are

```math
f_i(x)=x_1\exp\left(-\frac{x_2(t_i-x_3)^2}{2}\right)-y_i,
\qquad i=1,\ldots,15,
```

where ``t_i=(8-i)/2`` and

```math
\begin{aligned}
y_1=y_{15}&=0.0009, & y_2=y_{14}&=0.0044,\\
y_3=y_{13}&=0.0175, & y_4=y_{12}&=0.0540,\\
y_5=y_{11}&=0.1295, & y_6=y_{10}&=0.2420,\\
y_7=y_9&=0.3521, & y_8&=0.3989.
\end{aligned}
```

### MGH16 — Brown–Dennis

For ``m\geq4``, let ``F:\mathbb{R}^4\to\mathbb{R}^m`` be defined by
``F(x)=(f_1(x),\ldots,f_m(x))``. The objectives are

```math
f_i(x)=\left(x_1+t_ix_2-\exp(t_i)\right)^2
       +\left(x_3+x_4\sin(t_i)-\cos(t_i)\right)^2,
\qquad i=1,\ldots,m,
```

where ``t_i=i/5`` and
``x\in[-25,25]\times[-5,5]\times[-5,5]\times[-1,1]``.

### MGH26 — Trigonometric

For ``n\geq1``, let ``F:\mathbb{R}^n\to\mathbb{R}^n`` be defined by
``F(x)=(f_1(x),\ldots,f_n(x))`` for ``x\in[-1,1]^n``. The objectives are

```math
f_i(x)=\left(
n-\sum_{j=1}^{n}\cos(x_j)
+i\left(1-\cos(x_i)\right)-\sin(x_i)
\right)^2,
\qquad i=1,\ldots,n.
```

### MGH33 — Linear function, rank 1

For independent ``n\geq2`` and ``m\geq2``, let
``F:\mathbb{R}^n\to\mathbb{R}^m`` be defined by
``F(x)=(f_1(x),\ldots,f_m(x))`` for ``x\in[-1,1]^n``. The objectives are

```math
f_i(x)=\left(i\sum_{j=1}^{n}jx_j-1\right)^2,
\qquad i=1,\ldots,m.
```

## Usage

The following example uses the linear rank-1 dimensions reported in
[Mita2019](@cite).

```jldoctest mgh_usage
julia> using MOProblems

julia> prob = MGH33(nvar = 10, nobj = 4);

julia> x = zeros(prob.nvar);

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(4, (4, 10))
```

## Constructor reference

```@docs
MOProblems.MGH9
MOProblems.MGH16
MOProblems.MGH26
MOProblems.MGH33
```
