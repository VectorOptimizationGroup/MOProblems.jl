# Toint (Toi)

The `Toi` names retain the numbering of four problems in the partially separable
test collection of Ph. L. Toint [Toi1983](@cite). In that source each numbered
problem is a single-objective, unconstrained problem whose objective is the sum
of *element functions*, listed individually in the problem description. Mita,
Fukuda, and Yamashita [Mita2019](@cite) report multiobjective formulations based
on four of these problems in Appendix A of their numerical study, taking the
element functions of a problem as the objectives of a vector-valued problem and
adding box constraints, since the originals are unconstrained. The constructors
in MOProblems.jl follow those formulations, and restore the variable dimension
of the original collection for `Toi8`, `Toi9`, and `Toi10`.

The two sources name the problems differently; the package keeps Toint's
numbering.

| Constructor | [Toi1983](@cite) | [Mita2019](@cite) |
|:---|:---|:---|
| `Toi4` | Problem 4 | Toint (TOI4) |
| `Toi8` | Problem 8, TRIDIA | TRIDIA |
| `Toi9` | Problem 9, Shifted TRIDIA | Shifted TRIDIA |
| `Toi10` | Problem 10, Rosenbrock | Rosenbrock |

## Overview

`Toi4` has fixed dimensions: it has two element functions in [Toi1983](@cite)
and therefore two objectives, matching the instance of [Mita2019](@cite).

`Toi8`, `Toi9`, and `Toi10` are stated for a variable dimension in
[Toi1983](@cite), and the constructors accept `n >= 2` and couple the
dimensions accordingly: `nvar = nobj = n` for `Toi8` and `Toi9`, and
`nvar = n`, `nobj = n - 1` for `Toi10`. Their defaults reproduce the instances
of [Mita2019](@cite), namely `n = 3` for `Toi8` and `n = 4` for the other two.

| Problem | Dimension behavior | Configurable parameters | Default `nvar` | Default `nobj` | Bounds |
|:---|:---|:---|---:|---:|:---|
| `Toi4` | Fixed | — | 4 | 2 | ``[-2,5]^4`` |
| `Toi8` | Coupled | `n >= 2`, with `nvar = nobj = n` | 3 | 3 | ``[-1,1]^n`` |
| `Toi9` | Coupled | `n >= 2`, with `nvar = nobj = n` | 4 | 4 | ``[-1,1]^n`` |
| `Toi10` | Coupled | `n >= 2`, with `nvar = n` and `nobj = n - 1` | 4 | 3 | ``[-2,2]^n`` |

Analytical Jacobians are registered for all four constructors. Hessians are not
registered. The catalog metadata classifies every objective in each default
instance as not strictly convex (`:not_strictly_convex`).

## Mathematical formulations

### Toi4

Let ``F:\mathbb{R}^4\to\mathbb{R}^2`` be defined by ``F(x)=(f_1(x),f_2(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= x_1^2+x_2^2+1,\\
f_2(x) &= 0.5\left[(x_1-x_2)^2+(x_3-x_4)^2\right]+1.
\end{aligned}
```

### Toi8 — TRIDIA

For ``n\geq2``, let ``F:\mathbb{R}^n\to\mathbb{R}^n`` be defined by
``F(x)=(f_1(x),\ldots,f_n(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= (2x_1-1)^2,\\
f_i(x) &= i(2x_{i-1}-x_i)^2,\qquad i=2,\ldots,n.
\end{aligned}
```

### Toi9 — Shifted TRIDIA

For ``n\geq2``, let ``F:\mathbb{R}^n\to\mathbb{R}^n`` be defined by
``F(x)=(f_1(x),\ldots,f_n(x))``. The objectives are

```math
\begin{aligned}
f_1(x) &= (2x_1-1)^2+x_2^2,\\
f_i(x) &= i(2x_{i-1}-x_i)^2-(i-1)x_{i-1}^2+ix_i^2,\qquad i=2,\ldots,n-1,\\
f_n(x) &= n(2x_{n-1}-x_n)^2-(n-1)x_{n-1}^2.
\end{aligned}
```

The middle range is empty when ``n=2``, in which case ``F=(f_1,f_2)`` with
``f_2`` given by the last expression.

### Toi10 — Rosenbrock

For ``n\geq2``, let ``F:\mathbb{R}^n\to\mathbb{R}^{n-1}`` be defined by
``F(x)=(f_1(x),\ldots,f_{n-1}(x))``. The objectives are

```math
f_i(x)=100\left(x_{i+1}-x_i^2\right)^2+\left(x_{i+1}-1\right)^2,
\qquad i=1,\ldots,n-1.
```

## Usage

```julia
using MOProblems

prob = Toi9(n = 4)
x = fill(0.5, prob.nvar)

values = eval_f(prob, x)
J = eval_jacobian(prob, x)
```

## Constructor reference

```@docs
MOProblems.Toi4
MOProblems.Toi8
MOProblems.Toi9
MOProblems.Toi10
```
