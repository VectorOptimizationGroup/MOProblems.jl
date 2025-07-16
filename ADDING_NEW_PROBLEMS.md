# How to Add a New Problem to MOProblems.jl

This guide provides a step-by-step process for adding a new multiobjective optimization problem to the `MOProblems.jl` package. Following these instructions ensures that the new problem is correctly integrated, tested, and available through the package's interface.

The process involves three main steps:
1.  **Create a metadata file**: Defines the static properties of the problem.
2.  **Create the problem implementation file**: Contains the mathematical definition of the problem (objective functions, gradients, etc.).
3.  **Update the main module**: Registers the new problem so it can be used.

---

### Step 1: Create the Metadata File

The metadata file stores essential, static information about the problem. This allows the package to filter and query problems without having to instantiate them first.

1.  **Location**: Create a new file in the `src/Meta/` directory.
2.  **Naming Convention**: The file must be named after the problem, in uppercase, followed by the `.jl` extension. For a problem named `MYPROB1`, the file should be `src/Meta/MYPROB1.jl`.
3.  **Content**: The file must contain a `Dict` named `<ProblemName>_meta`. This dictionary holds the metadata keys.

**Template (`src/Meta/MYPROB1.jl`):**

```julia
MYPROB1_meta = Dict(
    :nvar => 5,                    # Number of variables
    :variable_nvar => false,       # True if nvar can be changed by the user
    :nobj => 2,                    # Number of objectives
    :ncon => 0,                    # Number of constraints
    :variable_ncon => false,       # True if ncon can be changed
    :minimize => true,             # Set to `true` for minimization, `false` for maximization
    :name => "MYPROB1",            # The official name of the problem
    :has_equalities_only => false, # True if all constraints are equalities
    :has_inequalities_only => false, # True if all constraints are inequalities (g(x) <= 0)
    :has_bounds => true,           # True if the variables have box constraints (lower/upper bounds)
    :m_objtype => :nonlinear,      # Objective type, one of [:linear, :nonlinear, :mixed, :other]
    :contype => :unconstrained,    # Constraint type, one of [:unconstrained, :linear, :quadratic, :general]
    :origin => :academic,          # Origin, one of [:academic, :modelling, :real, :unknown]
    :has_jacobian => true,         # Set to `true` if you provide an analytical Jacobian function
    :convexity => [:strictly_convex, :non_convex], # Convexity of each objective: [:strictly_convex, :convex, :non_convex, :unknown]
)

# Optional helper functions for problems with a variable number of dimensions
get_MYPROB1_nvar(; kwargs...) = 5
get_MYPROB1_nobj(; kwargs...) = 2
get_MYPROB1_ncon(; kwargs...) = 0
```

---

### Step 2: Create the Problem Implementation File

This file contains the core logic of the problem, including the Julia functions for the objectives and their gradients.

1.  **Location**: Create a new file in the `src/problems/` directory.
2.  **Naming Convention**: The preferred naming convention is `authorYEAR.jl` (e.g., `doe2024.jl`), especially for problems from academic papers. If a file for that source already exists, add the new problem to it. If the source is not a paper, use a descriptive, lowercase name (e.g., `custom_problems.jl`).
3.  **Content**: This file will contain a constructor function for your problem.

**Template (`src/problems/doe2024.jl`):**

```julia
"""
    A brief description of the problem source.

    Reference:
    - Doe, J. (2024). A New Problem for Multiobjective Optimization. Journal of Something.
"""
# ------------------------- MYPROB1 -------------------------
"""
    MYPROB1()

A summary of the problem's characteristics.
- 5 variables
- 2 objectives
- Objectives:
  - f₁(x) = ...
  - f₂(x) = ...
- Bounds: [-10, 10] for all variables
- Convexity: [strictly convex, non-convex]
"""
function MYPROB1(; T::Type{<:AbstractFloat}=Float64)
    # 1. Get metadata
    meta = META["MYPROB1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # 2. Define objective functions
    f1 = x -> sum(x.^2)
    f2 = x -> (x[1] - 1)^2 + (x[2] - 2)^2

    # 3. Define gradients (if has_jacobian = true)
    df1_dx = x -> T(2) .* x
    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2) * (x[1] - 1)
        grad[2] = T(2) * (x[2] - 2)
        return grad
    end

    # 4. Define the full Jacobian matrix
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    # 5. Create the MOProblem instance
    prob = MOProblem(
        n,
        m,
        [f1, f2]; # A vector with the objective functions
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-10.0), n), fill(T(10.0), n)), # Define bounds if has_bounds is true
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian, # The full jacobian function
        jacobian_by_row = [df1_dx, df2_dx], # A vector with the gradient of each objective
        convexity = meta[:convexity]
    )

    # 6. Register the problem instance
    register_problem(prob)
    return prob
end
```

---

### Step 3: Update the Main Module File

Finally, you must make the package aware of your new problem by including the implementation file and exporting the constructor.

1.  **File to Modify**: `src/MOProblems.jl`.

2.  **Include the File**: Find the section with other `include` statements for problems and add yours.

    ```julia
    # src/MOProblems.jl

    # ... other includes ...
    include("problems/zdt2000.jl")
    include("problems/ap2014.jl")
    include("problems/bk1996.jl")
    include("problems/aas2025.jl")
    include("problems/dd1998.jl")
    include("problems/doe2024.jl") # <-- ADD YOUR FILE HERE
    ```

3.  **Export the Constructor**: Find the section with `export` statements for problem constructors and add yours.

    ```julia
    # src/MOProblems.jl

    # ... other exports ...
    export ZDT1, ZDT2, ZDT3, ZDT4, ZDT6
    export AP1, AP2, AP3, AP4, BK1
    export AAS1, AAS2
    export DD1
    export MYPROB1 # <-- ADD YOUR PROBLEM NAME HERE
    ```

---

### Final Checklist

- [ ] Created `src/Meta/MYPROB1.jl` with the correct `_meta` dictionary.
- [ ] Created `src/problems/doe2024.jl` with the `MYPROB1` constructor function.
- [ ] The constructor correctly defines objectives, gradients (if applicable), and creates the `MOProblem` object.
- [ ] The constructor calls `register_problem(prob)`.
- [ ] `src/MOProblems.jl` has been updated to `include` the new problem file.
- [ ] `src/MOProblems.jl` has been updated to `export` the new problem constructor.

After these steps, the new problem `MYPROB1` will be fully integrated into the package. It's also highly recommended to add a test for the new problem in the `test/` directory to validate its correctness, especially the analytical derivatives. The test suite in `test/derivative_validation.jl` will automatically test any problem where `:has_jacobian` is `true`. 