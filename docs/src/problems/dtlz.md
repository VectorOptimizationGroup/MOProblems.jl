# Deb–Thiele–Laumanns–Zitzler (DTLZ)

This family comprises `DTLZ1` through `DTLZ5`. These test problems are described
in Chapter 6, “Scalable Test Problems for Evolutionary Multiobjective
Optimization,” pages 105–145 of *Evolutionary Multiobjective Optimization:
Theoretical Advances and Applications* [DTLZ2005](@cite).

## Overview

For all five constructors, `k >= 1`, `m >= 2`, `nvar = k + m - 1`, and
`nobj = m`. DTLZ4 additionally requires `alpha > 0`. The default dimensions
and componentwise bounds are shown below.

| Problem | `k` | `m` | `alpha` | `nvar` | `nobj` | Lower bound | Upper bound |
|:---|---:|---:|---:|---:|---:|---:|---:|
| `DTLZ1` | 5 | 3 | — | 7 | 3 | 0.0 | 1.0 |
| `DTLZ2` | 10 | 3 | — | 12 | 3 | 0.0 | 1.0 |
| `DTLZ3` | 10 | 3 | — | 12 | 3 | 0.0 | 1.0 |
| `DTLZ4` | 10 | 3 | 100.0 | 12 | 3 | 0.0 | 1.0 |
| `DTLZ5` | 10 | 5 | — | 14 | 5 | 0.0 | 1.0 |

Analytical Jacobians are registered for all five constructors. **Hessians are
not registered**. The catalog metadata classifies every objective in `DTLZ1` through `DTLZ5`
as not strictly convex (`:not_strictly_convex`). This is distinct from
`nothing`, which indicates that strict-convexity information is not available
for a problem.

## Mathematical formulations

The formulas below describe the objective functions implemented by the
constructors. For each problem, let ``F:\mathbb{R}^n \to \mathbb{R}^m`` be
defined by ``F(x)=(f_1(x),\ldots,f_m(x))``, where ``n = k + m - 1``.

### DTLZ1

The objectives are

```math
\begin{aligned}
f_1(x) &= \frac{1}{2}(1+g(x))x_1x_2\cdots x_{m-1},\\
f_2(x) &= \frac{1}{2}(1+g(x))x_1x_2\cdots x_{m-2}(1-x_{m-1}),\\
&\ \vdots\\
f_{m-1}(x) &= \frac{1}{2}(1+g(x))x_1(1-x_2),\\
f_m(x) &= \frac{1}{2}(1+g(x))(1-x_1).
\end{aligned}
```

where

```math
g(x) = 100\left[k + \sum_{r=m}^{n}
\left((x_r-0.5)^2-\cos\left(20\pi(x_r-0.5)\right)\right)\right].
```

### DTLZ2

The objectives are

```math
\begin{aligned}
f_1(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\cos\left(\frac{\pi x_2}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-1}}{2}\right),\\
f_2(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\cos\left(\frac{\pi x_2}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-2}}{2}\right)
\sin\left(\frac{\pi x_{m-1}}{2}\right),\\
&\ \vdots\\
f_{m-1}(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\sin\left(\frac{\pi x_2}{2}\right),\\
f_m(x) &= (1+g(x))\sin\left(\frac{\pi x_1}{2}\right).
\end{aligned}
```

where

```math
g(x) = \sum_{r=m}^{n}(x_r-0.5)^2.
```

### DTLZ3

The objectives are

```math
\begin{aligned}
f_1(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\cos\left(\frac{\pi x_2}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-1}}{2}\right),\\
f_2(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\cos\left(\frac{\pi x_2}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-2}}{2}\right)
\sin\left(\frac{\pi x_{m-1}}{2}\right),\\
&\ \vdots\\
f_{m-1}(x) &= (1+g(x))\cos\left(\frac{\pi x_1}{2}\right)
\sin\left(\frac{\pi x_2}{2}\right),\\
f_m(x) &= (1+g(x))\sin\left(\frac{\pi x_1}{2}\right).
\end{aligned}
```

where

```math
g(x) = 100\left[k + \sum_{r=m}^{n}
\left((x_r-0.5)^2-\cos\left(20\pi(x_r-0.5)\right)\right)\right].
```

### DTLZ4

The objectives are

```math
\begin{aligned}
f_1(x) &= (1+g(x))\cos\left(\frac{\pi x_1^\alpha}{2}\right)
\cos\left(\frac{\pi x_2^\alpha}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-1}^\alpha}{2}\right),\\
f_2(x) &= (1+g(x))\cos\left(\frac{\pi x_1^\alpha}{2}\right)
\cos\left(\frac{\pi x_2^\alpha}{2}\right)\cdots
\cos\left(\frac{\pi x_{m-2}^\alpha}{2}\right)
\sin\left(\frac{\pi x_{m-1}^\alpha}{2}\right),\\
&\ \vdots\\
f_{m-1}(x) &= (1+g(x))\cos\left(\frac{\pi x_1^\alpha}{2}\right)
\sin\left(\frac{\pi x_2^\alpha}{2}\right),\\
f_m(x) &= (1+g(x))\sin\left(\frac{\pi x_1^\alpha}{2}\right).
\end{aligned}
```

where

```math
g(x) = \sum_{r=m}^{n}(x_r-0.5)^2.
```

### DTLZ5

The objectives are

```math
\begin{aligned}
f_1(x) &= (1+g(x))\cos\left(\frac{\pi\theta_1}{2}\right)
\cos\left(\frac{\pi\theta_2}{2}\right)\cdots
\cos\left(\frac{\pi\theta_{m-1}}{2}\right),\\
f_2(x) &= (1+g(x))\cos\left(\frac{\pi\theta_1}{2}\right)
\cos\left(\frac{\pi\theta_2}{2}\right)\cdots
\cos\left(\frac{\pi\theta_{m-2}}{2}\right)
\sin\left(\frac{\pi\theta_{m-1}}{2}\right),\\
&\ \vdots\\
f_{m-1}(x) &= (1+g(x))\cos\left(\frac{\pi\theta_1}{2}\right)
\sin\left(\frac{\pi\theta_2}{2}\right),\\
f_m(x) &= (1+g(x))\sin\left(\frac{\pi\theta_1}{2}\right).
\end{aligned}
```

where

```math
\theta_1 = x_1,
\qquad
\theta_j = \frac{\pi}{4(1+g(x))}\left(1+2g(x)x_j\right),
\quad j=2,\ldots,m-1,
```

and

```math
g(x) = \sum_{r=m}^{n}(x_r-0.5)^2.
```

## Usage

```julia
using MOProblems

prob = DTLZ2(k = 10, m = 4)
x = fill(0.5, prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.DTLZ1
MOProblems.DTLZ2
MOProblems.DTLZ3
MOProblems.DTLZ4
MOProblems.DTLZ5
```
