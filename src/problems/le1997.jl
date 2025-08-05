"""
J. Lis and A. E. Eiben, "A multi-sexual genetic algorithm for multiobjective optimization," 
Proceedings of 1997 IEEE International Conference on Evolutionary Computation (ICEC '97), 
Indianapolis, IN, USA, 1997, pp. 59-64, doi: 10.1109/ICEC.1997.592269.
"""

# ------------------------- LE1 -------------------------
"""
    LE1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = (x₁² + x₂²)^0.125
    f₂(x) = ((x₁ - 0.5)² + (x₂ - 0.5)²)^0.25
- Bounds: [1, 10] for all variables
- Convexity: non-convex for both objectives
"""
function LE1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["LE1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        # f₁(x) = (x₁² + x₂²)^0.125
        return (x[1]^2 + x[2]^2)^T(0.125)
    end

    f2 = function (x)
        # f₂(x) = ((x₁ - 0.5)² + (x₂ - 0.5)²)^0.25
        return ((x[1] - T(0.5))^2 + (x[2] - T(0.5))^2)^T(0.25)
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        
        # Calculate common term: (x₁² + x₂²)^(-0.875)
        t = T(0.25) * (x[1]^2 + x[2]^2)^T(-0.875)
        
        # ∂f₁/∂x₁ = x₁ * 0.25 * (x₁² + x₂²)^(-0.875)
        grad[1] = x[1] * t
        
        # ∂f₁/∂x₂ = x₂ * 0.25 * (x₁² + x₂²)^(-0.875)
        grad[2] = x[2] * t
        
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        
        # Calculate common term: ((x₁ - 0.5)² + (x₂ - 0.5)²)^(-0.75)
        t = T(0.5) * ((x[1] - T(0.5))^2 + (x[2] - T(0.5))^2)^T(-0.75)
        
        # ∂f₂/∂x₁ = (x₁ - 0.5) * 0.5 * ((x₁ - 0.5)² + (x₂ - 0.5)²)^(-0.75)
        grad[1] = (x[1] - T(0.5)) * t
        
        # ∂f₂/∂x₂ = (x₂ - 0.5) * 0.5 * ((x₁ - 0.5)² + (x₂ - 0.5)²)^(-0.75)
        grad[2] = (x[2] - T(0.5)) * t
        
        return grad
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Bounds: [1, 10] for all variables
    lower = fill(T(1.0), n)
    upper = fill(T(10.0), n)
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