"""
Y. Jin, M. Olhofer and B. Sendhoff, "Dynamic Weighted Aggregation for evolutionary multi-objective optimization: why does it work and how?," Proceedings of the 3rd Annual Conference on Genetic and Evolutionary Computation (GECCO'01), San Francisco, California, 2001, pp. 1042-1049.
"""

# ------------------------- JOS1 -------------------------
"""
    JOS1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = (1/n) * Σ(x[i]²) = average of squared variables
    f₂(x) = (1/n) * Σ((x[i] - 2.0)²) = average of squared differences from 2.0
- Bounds: [-100, 100] for all variables
- Convexity: strictly convex for both objectives
"""
function JOS1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["JOS1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        sum_squares = zero(T)
        for i in 1:n
            sum_squares += x[i]^2
        end
        return sum_squares / T(n)
    end

    f2 = function (x)
        sum_squares = zero(T)
        for i in 1:n
            sum_squares += (x[i] - T(2.0))^2
        end
        return sum_squares / T(n)
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        for i in 1:n
            grad[i] = T(2.0) * x[i] / T(n)
        end
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        for i in 1:n
            grad[i] = T(2.0) * (x[i] - T(2.0)) / T(n)
        end
        return grad
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Bounds: [-100, 100] for all variables
    lower = fill(T(-100.0), n)
    upper = fill(T(100.0), n)
    bounds = (lower, upper)

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