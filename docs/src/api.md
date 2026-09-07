# API Reference

This reference presents the docstrings of the types and functions shared by
the benchmark problems, including their signatures, arguments, and behavior.
For workflows that connect these APIs, see [Evaluation and Derivatives](@ref)
and [Catalog and Metadata](@ref).

## Evaluation

General constraints use the representation ``l_c \leq c(x) \leq u_c``, stored
in `prob.lcon` and `prob.ucon`. Rows with equal lower and upper bounds are
equalities; all other rows are inequalities. Objective and constraint
derivatives have separate evaluation functions.

Derivative metadata records whether an analytical evaluator is registered; it
does not assert differentiability at every boundary point of a benchmark's
domain. Family pages document problem-specific restrictions, and registered
evaluators may throw a `DomainError` where an analytical derivative is
undefined.

```@docs
MOProblems.eval_f
MOProblems.eval_f!
MOProblems.eval_c
MOProblems.eval_c!
MOProblems.eval_jacobian
MOProblems.eval_jacobian!
MOProblems.eval_jacobian_row
MOProblems.eval_jacobian_row!
MOProblems.eval_constraint_jacobian
MOProblems.eval_constraint_jacobian!
MOProblems.eval_constraint_jacobian_row
MOProblems.eval_constraint_jacobian_row!
MOProblems.eval_hessian
MOProblems.eval_hessian!
MOProblems.eval_hessian_row
MOProblems.eval_hessian_row!
MOProblems.eval_constraint_hessian
MOProblems.eval_constraint_hessian!
MOProblems.eval_constraint_hessian_row
MOProblems.eval_constraint_hessian_row!
```

## Catalog

For a worked example of selecting candidates, interpreting catalog defaults,
and constructing an instance, see [Catalog and Metadata](@ref).

```@docs
MOProblems.get_problem_names
MOProblems.filter_problems
```

## Core Types

```@docs
MOProblems.MOProblem
MOProblems.ProblemMeta
MOProblems.AbstractDimensionSpec
MOProblems.FixedDimension
MOProblems.VariableNvar
MOProblems.VariableNobj
MOProblems.IndependentDimension
MOProblems.ParametricDimension
MOProblems.CoupledDimension
MOProblems.default_nvar
MOProblems.default_nobj
```
