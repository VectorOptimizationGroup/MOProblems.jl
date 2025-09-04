"""Jiangming Mao, K. Hirasawa, Jinlu Hu, J. Murata, "Genetic symbiosis algorithm for multiobjective optimization problem," 
Proceedings 9th IEEE International Workshop on Robot and Human Interactive Communication. IEEE RO-MAN 2000 (Cat. No.00TH8499), pp. 137-142, 2000.
DOI: 10.1109/ROMAN.2000.892484
"""
# ------------------------- MHHM1 -------------------------
"""
    MHHM1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 1 variable
- 3 objectives
- Objectives:
    f₁(x_1) = (x_1 - 0.8)²
    f₂(x_1) = (x_1 - 0.85)²
    f₃(x_1) = (x_1 - 0.9)²
- Bounds: [0, 1] for all variables
- Convexity: convex for all objectives
"""
function MHHM1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MHHM1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        # f₁(x_1) = (x_1 - 0.8)²
        return (x[1] - T(0.8))^2
    end

    f2 = function (x)
        # f₂(x_1) = (x_1 - 0.85)²
        return (x[1] - T(0.85))^2
    end

    f3 = function (x)
        # f₃(x_1) = (x_1 - 0.9)²
        return (x[1] - T(0.9))^2
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₁/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.8))
        
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₂/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.85))
        
        return grad
    end

    df3_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₃/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.9))
        
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

    # Bounds: [0, 1] for all variables
    lower = fill(T(0.0), n)
    upper = fill(T(1.0), n)
    bounds = (lower, upper)

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


# ------------------------- MHHM2 -------------------------
"""
    MHHM2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = (x₁ - 0.8)² + (x₂ - 0.6)²
    f₂(x) = (x₁ - 0.85)² + (x₂ - 0.7)²
    f₃(x) = (x₁ - 0.9)² + (x₂ - 0.6)²
- Bounds: [0, 1] for all variables
- Convexity: convex for all objectives
"""
function MHHM2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MHHM2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        # f₁(x) = (x₁ - 0.8)² + (x₂ - 0.6)²
        return (x[1] - T(0.8))^2 + (x[2] - T(0.6))^2
    end

    f2 = function (x)
        # f₂(x) = (x₁ - 0.85)² + (x₂ - 0.7)²
        return (x[1] - T(0.85))^2 + (x[2] - T(0.7))^2
    end

    f3 = function (x)
        # f₃(x) = (x₁ - 0.9)² + (x₂ - 0.6)²
        return (x[1] - T(0.9))^2 + (x[2] - T(0.6))^2
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₁/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.8))
        
        # ∂f₁/∂x₂
        grad[2] = T(2.0) * (x[2] - T(0.6))
        
        return grad
    end

    df2_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₂/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.85))
        
        # ∂f₂/∂x₂
        grad[2] = T(2.0) * (x[2] - T(0.7))
        
        return grad
    end

    df3_dx = function (x)
        grad = zeros(T, n)
        
        # ∂f₃/∂x₁
        grad[1] = T(2.0) * (x[1] - T(0.9))
        
        # ∂f₃/∂x₂
        grad[2] = T(2.0) * (x[2] - T(0.6))
        
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

    # Bounds: [0, 1] for all variables
    lower = fill(T(0.0), n)
    upper = fill(T(1.0), n)
    bounds = (lower, upper)

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