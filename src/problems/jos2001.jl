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

# ------------------------------------------------------------------
# The JOS2, JOS3 are the same as ZDT1 and ZDT2, respectively.
# ------------------------------------------------------------------

# ------------------------- JOS4 -------------------------
"""
    JOS4(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 20 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = (1 + 9*sum(x[2:n])/(n-1)) * (1 - (x₁/faux)^0.25 - (x₁/faux)^4)
    where faux = 1 + 9*sum(x[2:n])/(n-1)
- Bounds: [0.01, 1.0] for all variables
- Convexity: non-convex for both objectives
"""
function JOS4(; T::Type{<:AbstractFloat}=Float64)
    meta = META["JOS4"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        return x[1]
    end

    f2 = function (x)
        # Calculate faux = 1 + 9*sum(x[2:n])/(n-1)
        sum_x2n = zero(T)
        for i in 2:n
            sum_x2n += x[i]
        end
        faux = T(1.0) + T(9.0) * sum_x2n / T(n - 1)
        
        # Calculate t = x[1]/faux
        t = x[1] / faux
        
        # f₂(x) = faux * (1 - t^0.25 - t^4)
        return faux * (T(1.0) - t^T(0.25) - t^T(4.0))
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        grad[1] = T(1.0)
        # grad[2:n] = 0.0 (already initialized)
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        
        # Calculate faux and t
        sum_x2n = zero(T)
        for i in 2:n
            sum_x2n += x[i]
        end
        faux = T(1.0) + T(9.0) * sum_x2n / T(n - 1)
        t = x[1] / faux
        
        # Gradient for x[1]: -0.25*t^(-0.75) - 4.0*t^3
        grad[1] = -T(0.25) * t^T(-0.75) - T(4.0) * t^T(3.0)
        
        # Gradient for x[2:n]: 9.0/(n-1) * (1 - 0.75*t^0.25 + 3.0*t^4)
        for i in 2:n
            grad[i] = T(9.0) / T(n - 1) * (T(1.0) - T(0.75) * t^T(0.25) + T(3.0) * t^T(4.0))
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

    # Bounds: [0.01, 1.0] for all variables
    lower = fill(T(0.01), n)
    upper = fill(T(1.0), n)
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