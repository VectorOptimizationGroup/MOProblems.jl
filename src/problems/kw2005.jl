"""
I.Y. Kim, O.L. de Weck, "Adaptive weighted-sum method for bi-objective optimization: Pareto front generation," 
Structural and Multidisciplinary Optimization, vol. 29, no. 2, pp. 149-158, 2005.
DOI: 10.1007/s00158-004-0465-1
"""

# ------------------------- KW2 -------------------------
"""
    KW2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = -3(1-x₁)²exp(-x₁²-(x₂+1)²) + 10(x₁/5-x₁³-x₂⁵)exp(-x₁²-x₂²) + 3exp(-(x₁+2)²-x₂²) - 0.5(2x₁+x₂)
    f₂(x) = -3(1+x₂)²exp(-x₂²-(1-x₁)²) + 10(-x₂/5+x₂³+x₁⁵)exp(-x₁²-x₂²) + 3exp(-(2-x₂)²-x₁²)
- Bounds: [-3, 3] for all variables
- Convexity: non-convex for both objectives
"""
function KW2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["KW2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        # f₁(x) = -3(1-x₁)²exp(-x₁²-(x₂+1)²) + 10(x₁/5-x₁³-x₂⁵)exp(-x₁²-x₂²) + 3exp(-(x₁+2)²-x₂²) - 0.5(2x₁+x₂)
        term1 = -T(3.0) * (T(1.0) - x[1])^2 * exp(-x[1]^2 - (x[2] + T(1.0))^2)
        term2 = T(10.0) * (x[1]/T(5.0) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2)
        term3 = T(3.0) * exp(-(x[1] + T(2.0))^2 - x[2]^2)
        term4 = -T(0.5) * (T(2.0) * x[1] + x[2])
        return term1 + term2 + term3 + term4
    end

    f2 = function (x)
        # f₂(x) = -3(1+x₂)²exp(-x₂²-(1-x₁)²) + 10(-x₂/5+x₂³+x₁⁵)exp(-x₁²-x₂²) + 3exp(-(2-x₂)²-x₁²)
        term1 = -T(3.0) * (T(1.0) + x[2])^2 * exp(-x[2]^2 - (T(1.0) - x[1])^2)
        term2 = T(10.0) * (-x[2]/T(5.0) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2)
        term3 = T(3.0) * exp(-(T(2.0) - x[2])^2 - x[1]^2)
        return term1 + term2 + term3
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₁/∂x₁
        grad[1] = T(6.0) * (T(1.0) - x[1]) * exp(-x[1]^2 - (x[2] + T(1.0))^2) +
                   T(6.0) * (T(1.0) - x[1])^2 * exp(-x[1]^2 - (x[2] + T(1.0))^2) * x[1] +
                   T(10.0) * (T(1.0)/T(5.0) - T(3.0) * x[1]^2) * exp(-x[1]^2 - x[2]^2) -
                   T(20.0) * (x[1]/T(5.0) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2) * x[1] -
                   T(6.0) * exp(-(x[1] + T(2.0))^2 - x[2]^2) * (x[1] + T(2.0)) - T(1.0)
        
        # ∂f₁/∂x₂
        grad[2] = T(6.0) * (T(1.0) - x[1])^2 * exp(-x[1]^2 - (x[2] + T(1.0))^2) * (x[2] + T(1.0)) -
                   T(50.0) * x[2]^4 * exp(-x[1]^2 - x[2]^2) -
                   T(10.0) * (x[1]/T(5.0) - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2) * T(2.0) * x[2] -
                   T(6.0) * exp(-(x[1] + T(2.0))^2 - x[2]^2) * x[2] - T(0.5)
        
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₂/∂x₁
        grad[1] = -T(6.0) * (T(1.0) + x[2])^2 * exp(-x[2]^2 - (T(1.0) - x[1])^2) * (T(1.0) - x[1]) +
                   T(50.0) * x[1]^4 * exp(-x[1]^2 - x[2]^2) -
                   T(20.0) * (-x[2]/T(5.0) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2) * x[1] -
                   T(6.0) * exp(-(T(2.0) - x[2])^2 - x[1]^2) * x[1]
        
        # ∂f₂/∂x₂
        grad[2] = -T(6.0) * (T(1.0) + x[2]) * exp(-x[2]^2 - (T(1.0) - x[1])^2) +
                   T(6.0) * (T(1.0) + x[2])^2 * exp(-x[2]^2 - (T(1.0) - x[1])^2) * x[2] +
                   T(10.0) * (-T(1.0)/T(5.0) + T(3.0) * x[2]^2) * exp(-x[1]^2 - x[2]^2) -
                   T(20.0) * (-x[2]/T(5.0) + x[2]^3 + x[1]^5) * exp(-x[1]^2 - x[2]^2) * x[2] +
                   T(6.0) * exp(-(T(2.0) - x[2])^2 - x[1]^2) * (T(2.0) - x[2])
        
        return grad
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Bounds: [-3, 3] for all variables
    lower = fill(T(-3.0), n)
    upper = fill(T(3.0), n)
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