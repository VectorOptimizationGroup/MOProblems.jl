# API Reference

This page documents the types and functions shared by the benchmark problems.

## Evaluation

```@docs
MOProblems.eval_f
MOProblems.eval_f!
MOProblems.eval_jacobian
MOProblems.eval_jacobian!
MOProblems.eval_jacobian_row
MOProblems.eval_jacobian_row!
MOProblems.eval_hessian
MOProblems.eval_hessian!
MOProblems.eval_hessian_row
MOProblems.eval_hessian_row!
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
