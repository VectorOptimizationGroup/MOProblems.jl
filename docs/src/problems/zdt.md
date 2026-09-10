# Zitzler–Deb–Thiele (ZDT)

This family comprises `ZDT1`, `ZDT2`, `ZDT3`, `ZDT4`, and `ZDT6`. These are the
real-valued test functions ``\mathcal{T}_1``–``\mathcal{T}_4`` and
``\mathcal{T}_6`` of Definition 4, Equations (7)–(10) and (12), of “Comparison
of Multiobjective Evolutionary Algorithms: Empirical Results”
[ZDT2000](@cite). The source's remaining test function, ``\mathcal{T}_5``
(Equation (11)), is defined over binary strings rather than real variables, and
the package provides no constructor for it.

!!! note "Alternative names"
    The formulations of `ZDT1`, `ZDT2`, and `ZDT3` also appear as ``F_2``,
    ``F_3``, and ``F_5`` of Jin, Olhofer, and Sendhoff [JOS2001](@cite), which
    attributes them to this source. See the
    [Jin–Olhofer–Sendhoff (JOS)](@ref) page.

## Overview

Every constructor takes the number of variables `n` as its only parameter and
requires `n >= 2`, giving `nvar = n` and `nobj = 2`. The default dimensions and
componentwise bounds are shown below.

| Problem | Source function | Default `nvar` | `nobj` | Lower bounds | Upper bounds |
|:---|:---|---:|---:|:---|:---|
| `ZDT1` | ``\mathcal{T}_1`` | 30 | 2 | ``[0,\ldots,0]`` | ``[1,\ldots,1]`` |
| `ZDT2` | ``\mathcal{T}_2`` | 30 | 2 | ``[0,\ldots,0]`` | ``[1,\ldots,1]`` |
| `ZDT3` | ``\mathcal{T}_3`` | 30 | 2 | ``[0,\ldots,0]`` | ``[1,\ldots,1]`` |
| `ZDT4` | ``\mathcal{T}_4`` | 10 | 2 | ``[0,-5,\ldots,-5]`` | ``[1,5,\ldots,5]`` |
| `ZDT6` | ``\mathcal{T}_6`` | 10 | 2 | ``[0,\ldots,0]`` | ``[1,\ldots,1]`` |

The default dimensions are the ones used by the source for each function.

Analytical Jacobians are registered for all five constructors. Hessians are
not registered. The catalog metadata classifies every objective in `ZDT1`
through `ZDT6` as not strictly convex (`:not_strictly_convex`).

!!! warning "Jacobian domain"
    Within the registered boxes, the full Jacobian is undefined on the
    following boundary sets, although both objective values remain defined:

    | Problems | Boundary set where the full Jacobian is undefined |
    |:---|:---|
    | `ZDT1`, `ZDT3`, `ZDT4` | The entire face ``x_1=0`` |
    | `ZDT6` | The segment ``x_2=\cdots=x_n=0``, with ``x_1\in[0,1]`` |

    For `ZDT1` and `ZDT4`, ``\partial f_2/\partial x_1`` equals
    ``-\tfrac{1}{2}\sqrt{g(x)/x_1}`` for ``x_1>0`` and tends to ``-\infty``
    as ``x_1\downarrow0``, since ``g(x)\geq1``. The additional trigonometric
    terms in `ZDT3` do not cancel this divergence. On the face ``x_1=0``,
    the partial derivatives of ``f_2`` with respect to ``x_2,\ldots,x_n``
    remain defined and equal the corresponding partial derivatives of ``g``.

    For `ZDT6`, let ``\mu=\frac{1}{n-1}\sum_{i=2}^{n}x_i``. For ``\mu>0``,
    the partial derivatives of ``f_2`` with respect to ``x_i``, ``i\geq2``,
    equal ``\left(1+(f_1/g)^2\right)\frac{9}{4(n-1)}\mu^{-3/4}`` and tend
    to ``+\infty`` as ``\mu\downarrow0``. The positive factor
    ``1+(f_1/g)^2`` prevents cancellation. Within the box, ``\mu=0`` is
    equivalent to ``x_2=\cdots=x_n=0``; the partial derivative with respect
    to ``x_1`` remains defined there and equals ``-2f_1f_1'``.

    Thus, ``f_2`` has no finite full gradient on these sets, even when
    considering one-sided variations within the box. Evaluating Jacobian row 2
    there throws a `DomainError`, whereas row 1 remains available through
    `eval_jacobian_row(prob, x, 1)`. A full `eval_jacobian(prob, x)` call
    also throws. `ZDT2` has a finite Jacobian throughout its registered box.

    No positive tolerance is imposed: at all other points within the boxes,
    the Jacobians are evaluated by the analytical formulas, subject to the
    range and precision of the input floating-point type.

## Mathematical formulations

All five problems share the structure

```math
F(x) = (f_1(x), f_2(x)),
\qquad
f_2(x) = g(x)\,h(f_1(x), g(x)),
```

where ``F:\Omega\to\mathbb{R}^2`` with ``n\geq2`` and ``\Omega\subset\mathbb{R}^n``
is the registered box listed above. The function ``f_1`` depends only on
``x_1``, and ``g`` depends only on ``x_2,\ldots,x_n``. The constructors differ
in ``f_1``, ``h``, and ``g``.

### ZDT1

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left(1-\sqrt{\frac{f_1(x)}{g(x)}}\right),
\end{aligned}
```

where

```math
g(x) = 1 + \frac{9}{n-1}\sum_{i=2}^{n}x_i.
```

### ZDT2

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left(1-\left(\frac{f_1(x)}{g(x)}\right)^{2}\right),
\end{aligned}
```

where

```math
g(x) = 1 + \frac{9}{n-1}\sum_{i=2}^{n}x_i.
```

### ZDT3

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left(1-\sqrt{\frac{f_1(x)}{g(x)}}
-\frac{f_1(x)}{g(x)}\sin\left(10\pi f_1(x)\right)\right),
\end{aligned}
```

where

```math
g(x) = 1 + \frac{9}{n-1}\sum_{i=2}^{n}x_i.
```

### ZDT4

The objectives are

```math
\begin{aligned}
f_1(x) &= x_1,\\
f_2(x) &= g(x)\left(1-\sqrt{\frac{f_1(x)}{g(x)}}\right),
\end{aligned}
```

where

```math
g(x) = 1 + 10(n-1) + \sum_{i=2}^{n}
\left(x_i^{2}-10\cos\left(4\pi x_i\right)\right).
```

### ZDT6

The objectives are

```math
\begin{aligned}
f_1(x) &= 1-\exp(-4x_1)\sin^{6}\left(6\pi x_1\right),\\
f_2(x) &= g(x)\left(1-\left(\frac{f_1(x)}{g(x)}\right)^{2}\right),
\end{aligned}
```

where

```math
g(x) = 1 + 9\left(\frac{1}{n-1}\sum_{i=2}^{n}x_i\right)^{0.25}.
```

## Usage

```jldoctest zdt_usage
julia> using MOProblems

julia> prob = ZDT1(30);

julia> x = fill(0.5, prob.nvar);

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(2, (2, 30))
```

## Constructor reference

```@docs
MOProblems.ZDT1
MOProblems.ZDT2
MOProblems.ZDT3
MOProblems.ZDT4
MOProblems.ZDT6
```
