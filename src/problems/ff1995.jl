"""
C. M. Fonseca and P. J. Fleming, "An Overview of Evolutionary Algorithms in Multiobjective Optimization," Evolutionary Computation, vol. 3, no. 1, pp. 1-16, March 1995. DOI: 10.1162/evco.1995.3.1.1.
"""

# ------------------------- FF1 -------------------------
"""
    FF1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 1 - exp(-(x₁ - 1)² - (x₂ + 1)²)
    f₂(x) = 1 - exp(-(x₁ + 1)² - (x₂ - 1)²)
- Bounds: [-1, 1] for each variable
- Convexity: non-convex for both objectives
"""
function FF1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["FF1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        return T(1) - exp(-((x[1] - T(1))^2 + (x[2] + T(1))^2))
    end

    f2 = function (x)
        return T(1) - exp(-((x[1] + T(1))^2 + (x[2] - T(1))^2))
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        exp_term = exp(-((x[1] - T(1))^2 + (x[2] + T(1))^2))
        return T[T(2) * (x[1] - T(1)) * exp_term,
                 T(2) * (x[2] + T(1)) * exp_term]
    end

    df2_dx = function (x)
        exp_term = exp(-((x[1] + T(1))^2 + (x[2] - T(1))^2))
        return T[T(2) * (x[1] + T(1)) * exp_term,
                 T(2) * (x[2] - T(1)) * exp_term]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (fill(T(-1), n), fill(T(1), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity],
    )
end 