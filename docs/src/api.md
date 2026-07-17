# API Reference

This page documents the types and functions shared by the benchmark problems.

## Evaluation

General constraints use the representation ``l_c \leq c(x) \leq u_c``, stored
in `prob.lcon` and `prob.ucon`. Rows with equal lower and upper bounds are
equalities; all other rows are inequalities. Objective and constraint
derivatives have separate evaluation functions.

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
MOProblems.ParametricDimension
MOProblems.CoupledDimension
MOProblems.default_nvar
MOProblems.default_nobj
MOProblems.dimension_parameters
MOProblems.dimension_relation
```
