# Zitzler–Laumanns–Thiele (ZLT)

This family is represented by the `ZLT1` constructor. The problem is the
multiobjective generalization of the Sphere Model listed in Table 1 of Zitzler,
Laumanns, and Thiele [ZLT2001](@cite), where it is named `SPH-m` and attributed
to Schaffer [Schaffer1985](@cite) and to Laumanns, Rudolph, and Schwefel
[Laumanns2001](@cite). The `ZLT1` name comes from Table XVI of Huband et al.
[Huband2006](@cite), which reproduces the same formulation and parameter domain
and identifies the source as the test suite of [ZLT2001](@cite). The package
follows that naming.

## Overview

`ZLT1(; nvar, nobj)` takes the number of variables and objectives as
independent parameters, and requires `nobj >= 2` and `nvar >= nobj`; the lower
bound on `nvar` comes from the objectives, which shift one coordinate each and so
need at least as many variables as objectives. The defaults `nvar = 100` and
`nobj = 2` reproduce the `SPH-2` instance evaluated in [ZLT2001](@cite). The
constructor retains the componentwise domain given in both sources.

| Problem | Dimension behavior | Configurable parameters | Default `nvar` | Default `nobj` | Lower bound | Upper bound |
|:---|:---|:---|---:|---:|---:|---:|
| `ZLT1` | Independent | `nobj >= 2`, `nvar >= nobj` | 100 | 2 | -1000 | 1000 |

`ZLT1` has an analytical Jacobian registered; objective Hessians are not registered. The catalog
metadata classifies every objective of the default instance as strictly convex (`:strictly_convex`).

!!! note "Dimensions used by the sources"
    [ZLT2001](@cite) fixes `nvar = 100` and evaluates the two instances
    `SPH-2` and `SPH-3`, with `nobj = 2` and `nobj = 3`, respectively. Its
    mathematical formulation is nonetheless general in the number of
    objectives. Huband et al. tabulate the objectives in a general indexed
    form without prescribing a number of variables or objectives, and state
    that `ZLT1` is the only problem of their survey that is scalable
    objective-wise. The constructor exposes both dimensions accordingly, and
    defaults to the smaller of the two published instances.

## Mathematical formulation

Let
``F:\mathbb{R}^n\to\mathbb{R}^m`` be defined by
``F(x)=(f_1(x),\ldots,f_m(x))`` for ``x\in[-1000,1000]^n``. For independent ``m\geq2`` and ``n\geq m``, the objectives are

```math
f_j(x)=(x_j-1)^2+\sum_{\substack{i=1\\i\neq j}}^{n}x_i^2,
\qquad j=1,\ldots,m.
```

## Usage

The following example uses the three-objective instance `SPH-3` of
[ZLT2001](@cite).

```jldoctest zlt_usage
julia> using MOProblems

julia> prob = ZLT1(nvar = 100, nobj = 3);

julia> x = zeros(prob.nvar);

julia> values = eval_f(prob, x);

julia> J = eval_jacobian(prob, x);

julia> (length(values), size(J))
(3, (3, 100))
```

## Constructor reference

```@docs
MOProblems.ZLT1
```
