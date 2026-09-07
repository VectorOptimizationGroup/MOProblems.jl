# Van Veldhuizen (VV)

This family is represented by the `MOP2`, `MOP3`, `MOP5`, `MOP6`, and `MOP7`
constructors. They come from Table 5.3 of the doctoral thesis of Van Veldhuizen
[VV1999](@cite), a suite that collects multiobjective problems already
published elsewhere and renumbers them. The names are positions in that table
rather than names given by the authors who created the problems; this package
implements five of its seven entries, which is why the numbering has gaps. The
formulations follow Table VIII of Huband et al. [Huband2006](@cite), which
reproduces the suite and identifies the source of each problem.

| Constructor | Source of the problem |
|:---|:---|
| `MOP2` | Fonseca and Fleming [Fonseca1995](@cite) |
| `MOP3` | Poloni et al. [Poloni1996](@cite) |
| `MOP5` | Viennet et al. [Viennet1996](@cite) |
| `MOP6` | derived from Deb [Deb1999](@cite) |
| `MOP7` | Viennet et al. [Viennet1996](@cite) |

`MOP6` is the one entry that was not published as a test problem in its own
right: Van Veldhuizen derived it from the problem construction method of Deb
[Deb1999](@cite). Huband et al. describe that method and the resulting problem
in detail.

## Overview

`MOP2` takes the number of variables `n` as its only parameter and requires
`n >= 1`; the other four have fixed dimensions. `MOP6` takes a shape parameter
`q`, described with its formulation below, which leaves its dimensions
unchanged. The registered bounds are the ones given by Van Veldhuizen and
reproduced by Huband et al.

| Problem | `nvar` | `nobj` | Lower bounds | Upper bounds | Strictly convex objectives |
|:---|---:|---:|:---|:---|:---|
| `MOP2` | `n`, default 3 | 2 | ``[-4,\ldots,-4]`` | ``[4,\ldots,4]`` | none |
| `MOP3` | 2 | 2 | ``[-\pi, -\pi]`` | ``[\pi, \pi]`` | ``f_2`` |
| `MOP5` | 2 | 3 | ``[-30, -30]`` | ``[30, 30]`` | ``f_2`` |
| `MOP6` | 2 | 2 | ``[0, 0]`` | ``[1, 1]`` | none |
| `MOP7` | 2 | 3 | ``[-400, -400]`` | ``[400, 400]`` | ``f_1``, ``f_2``, ``f_3`` |

The last column reports the catalog metadata; every objective not listed there
is classified as `:not_strictly_convex`. An analytical Jacobian is registered
for all five problems, and objective Hessians are not registered.

!!! note "Minimization convention for MOP3"
    Poloni et al. and Van Veldhuizen state `MOP3` as maximizing
    ``-\left[1+(A_1-B_1)^2+(A_2-B_2)^2\right]`` and
    ``-\left[(x_1+3)^2+(x_2+1)^2\right]``; Huband et al. likewise mark it as
    the one entry of Table VIII whose objectives are to be maximized. The
    constructor registers the negated objectives, so `MOP3` is minimized like
    every other problem in the package. The Pareto-optimal decision set is
    preserved, while reported objective values are sign-reversed.

!!! note "Bounds wider than in the original sources"
    For three problems, Van Veldhuizen widened the variable domain given in
    the source: ``[-2, 2]`` to ``[-4, 4]`` in `MOP2`, ``[-3, 3]`` to
    ``[-30, 30]`` in `MOP5`, and ``[-4, 4]`` to ``[-400, 400]`` in `MOP7`.
    Nothing else about the problems changed, so a run over the narrower box
    remains comparable with the results published in the source. `MOP3` and
    `MOP6` are unaffected.

## Mathematical formulations

### MOP2

Let ``F:\mathbb{R}^n \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``,
where ``n`` is the number of variables. The objectives are

```math
\begin{aligned}
f_1(x) &= 1-\exp\!\left(-\sum_{i=1}^{n}\left(x_i-\tfrac{1}{\sqrt{n}}\right)^2\right),\\
f_2(x) &= 1-\exp\!\left(-\sum_{i=1}^{n}\left(x_i+\tfrac{1}{\sqrt{n}}\right)^2\right).
\end{aligned}
```

### MOP3

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``.
The objectives are

```math
\begin{aligned}
f_1(x) &= 1+\left(A_1-B_1(x)\right)^2+\left(A_2-B_2(x)\right)^2,\\
f_2(x) &= (x_1+3)^2+(x_2+1)^2,
\end{aligned}
```

where the constants ``A_1``, ``A_2`` and the functions ``B_1``, ``B_2`` are

```math
\begin{aligned}
A_1 &= 0.5\sin 1-2\cos 1+\sin 2-1.5\cos 2,\\
A_2 &= 1.5\sin 1-\cos 1+2\sin 2-0.5\cos 2,\\
B_1(x) &= 0.5\sin x_1-2\cos x_1+\sin x_2-1.5\cos x_2,\\
B_2(x) &= 1.5\sin x_1-\cos x_1+2\sin x_2-0.5\cos x_2.
\end{aligned}
```

### MOP5

Let ``F:\mathbb{R}^2 \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= 0.5\left(x_1^2+x_2^2\right)+\sin\!\left(x_1^2+x_2^2\right),\\
f_2(x) &= \frac{(3x_1-2x_2+4)^2}{8}+\frac{(x_1-x_2+1)^2}{27}+15,\\
f_3(x) &= \frac{1}{x_1^2+x_2^2+1}-1.1\exp\!\left(-x_1^2-x_2^2\right).
\end{aligned}
```

### MOP6

Let ``F:\mathbb{R}^2 \to \mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``.
The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left(1-\left(\frac{x_1}{g(x)}\right)^{2}-\frac{x_1}{g(x)}\sin\!\left(2\pi q x_1\right)\right),
\end{aligned}
```

where

```math
g(x) = 1+10x_2.
```

The frequency ``q`` is the constructor parameter, an integer of at least 1
whose default is the value ``q = 4`` used by Van Veldhuizen. It sets how many
disconnected pieces the Pareto front has, which is the respect in which the
source describes this problem as scalable.

### MOP7

Let ``F:\mathbb{R}^2 \to \mathbb{R}^3`` be defined by
``F(x)=(f_1(x),f_2(x),f_3(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{(x_1-2)^2}{2}+\frac{(x_2+1)^2}{13}+3,\\
f_2(x) &= \frac{(x_1+x_2-3)^2}{36}+\frac{(-x_1+x_2+2)^2}{8}-17,\\
f_3(x) &= \frac{(x_1+2x_2-1)^2}{175}+\frac{(-x_1+2x_2)^2}{17}-13.
\end{aligned}
```

## Usage

```julia
using MOProblems

prob = MOP5()
x = [1.0, -2.0]

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.MOP2
MOProblems.MOP3
MOProblems.MOP5
MOProblems.MOP6
MOProblems.MOP7
```
