# Quick Usage and API

## Usage Example

```julia
using MOProblems

# === Direct Constructors ===

# Create problems
zdt1 = ZDT1()        # ZDT1 with 30 variables (default)
zdt1_50 = ZDT1(50)   # ZDT1 with 50 variables
ap1 = AP1()          # AP1 Problem
dgo1 = DGO1()        # DGO1 Problem

# Check problem properties
println("ZDT1 - Variables: ", zdt1.nvar, ", Objectives: ", zdt1.nobj)
println("Convexity: ", get_convexity(zdt1))

# === Static Queries ===

# List all available problems
names = get_problem_names()
println("Available problems: ", names)

# Filter problems by properties
convex_problems = filter_problems(any_convex=true)
bounded_problems = filter_problems(has_bounds=true)
jacobian_problems = filter_problems(has_jacobian=true)

println("Problems with convex objectives: ", convex_problems)
println("Problems with bounds: ", bounded_problems)
println("Problems with analytical Jacobian: ", jacobian_problems)

# === Function Evaluation ===

# Create a random point
x = rand(zdt1.nvar)

# Evaluate all objective functions
values = eval_f(zdt1, x)
println("Objective function values: ", values)

# Evaluate a specific objective function
f1 = eval_f(zdt1, x, 1)
println("Value of the first objective function: ", f1)

# Calculate the Jacobian matrix (gradients)
J = eval_jacobian(zdt1, x)
println("Jacobian matrix (", size(J), "):")
display(J)

# Calculate gradient of a specific function
grad1 = eval_jacobian_row(zdt1, x, 1)
println("Gradient of the first objective function: ", grad1)

```

## Query Functions

### Function Evaluation

- `eval_f(problem, x)`: Evaluates all objective functions at point x
- `eval_f(problem, x, i)`: Evaluates the i-th objective function at point x

### Jacobian Evaluation

- `eval_jacobian(problem, x)`: Calculates the Jacobian matrix at point x
- `eval_jacobian_row(problem, x, i)`: Calculates the gradient of the i-th objective function

### Convexity

- `get_convexity(problem)`: Returns convexity information for all objective functions
- `get_convexity(problem, i)`: Returns the convexity of the i-th objective function
- `is_strictly_convex(problem, i)`: Checks if the i-th objective function is strictly convex
- `is_convex(problem, i)`: Checks if the i-th objective function is convex (strict or not)
- `all_strictly_convex(problem)`: Checks if all objective functions are strictly convex
- `all_convex(problem)`: Checks if all objective functions are convex
- `any_strictly_convex(problem)`: Checks if at least one objective function is strictly convex
- `any_convex(problem)`: Checks if at least one objective function is convex

### Problem Registry

- `get_problem_names()`: Returns the names of all registered problems
- `filter_problems(...)`: Filters problems by specific properties

## Convexity Properties

The package supports convexity information for each objective function:

- `:strictly_convex`: The function is strictly convex
- `:convex`: The function is convex, but not necessarily strictly
- `:non_convex`: The function is not convex
- `:unknown`: The convexity of the function is unknown
