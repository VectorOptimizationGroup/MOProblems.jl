"""
J. Fliege, L. M. Graña Drummond, and B. F. Svaiter, "Newton's Method for Multiobjective Optimization," SIAM Journal on Optimization, vol. 20, no. 2, pp. 602-626, 2009. DOI: 10.1137/08071692X.
"""

# ------------------------- FDS -------------------------
"""
    FDS(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 5 variables
- 3 objectives
- Objectives:
    f₁(x) = (1/n²) ∑ᵢ i(xᵢ - i)⁴
    f₂(x) = exp(∑ᵢ xᵢ/n) + ||x||²
    f₃(x) = (1/(n(n+1))) ∑ᵢ i(n-i+1)exp(-xᵢ)
- Bounds: [-2, 2] for each variable
- Convexity: strictly convex for all objectives
"""
function FDS(; T::Type{<:AbstractFloat}=Float64)
    meta = META["FDS"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * (x[i] - T(i))^4
        end
        return sum_val / (T(n)^2)
    end

    f2 = function (x)
        return exp(sum(x) / T(n)) + norm(x)^2
    end

    f3 = function (x)
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * T(n - i + 1) * exp(-x[i])
        end
        return sum_val / (T(n) * T(n + 1))
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        for i in 1:n
            grad[i] = T(4) * T(i) * (x[i] - T(i))^3 / (T(n)^2)
        end
        return grad
    end

    df2_dx = function (x)
        exp_term = exp(sum(x) / T(n))
        grad = zeros(T, n)
        for i in 1:n
            grad[i] = exp_term / T(n) + T(2) * x[i]
        end
        return grad
    end

    df3_dx = function (x)
        grad = zeros(T, n)
        for i in 1:n
            grad[i] = -T(i) * T(n - i + 1) * exp(-x[i]) / (T(n) * T(n + 1))
        end
        return grad
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        J[3, :] = df3_dx(x)
        return J
    end

    bounds = (fill(T(-2), n), fill(T(2), n))

    return MOProblem(
        n, m, [f1, f2, f3];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx, df3_dx],
        convexity = meta[:convexity],
    )
end 