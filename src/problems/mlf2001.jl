"""
M. Molyneaux, D. Favrat, and G. B. Leyland, "A New Clustering Evolutionary Multi-Objective Optimisation Technique," Third International Symposium on Adaptative Systems, Institute of Cybernetics, Mathematics and Physics, 2001, pp. 41–47. URL: https://infoscience.epfl.ch/handle/20.500.14299/215484
"""

# ------------------------- MLF1 -------------------------
"""
    MLF1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 1 variable
- 2 objectives
- Objectives:
    f₁(x) = (1 + x₁/20) * sin(x₁)
    f₂(x) = (1 + x₁/20) * cos(x₁)
- Bounds: [0, 20] for the variable
- Convexity: non-convex for both objectives
"""
function MLF1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MLF1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        return (T(1) + x[1] / T(20)) * sin(x[1])
    end

    f2 = function (x)
        return (T(1) + x[1] / T(20)) * cos(x[1])
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        return T[sin(x[1]) / T(20) + (T(1) + x[1] / T(20)) * cos(x[1])]
    end

    df2_dx = function (x)
        return T[cos(x[1]) / T(20) - (T(1) + x[1] / T(20)) * sin(x[1])]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (fill(T(0), n), fill(T(20), n))

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

# ------------------------- MLF2 -------------------------
"""
    MLF2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives (minimization form):
    f₁(x) = -5 + ((x₁² + x₂ - 11)² + (x₁ + x₂² - 7)²) / 200
    f₂(x) = -5 + ((4x₁² + 2x₂ - 11)² + (2x₁ + 4x₂² - 7)²) / 200
- Bounds: [-100, 100] for each variable
- Convexity: non-convex for both objectives
"""
function MLF2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MLF2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions (minimization)
    # ------------------------------------------------------------------
    f1 = function (x)
        t1 = (x[1]^2 + x[2] - T(11))
        t2 = (x[1] + x[2]^2 - T(7))
        return -T(5) + (t1^2 + t2^2) / T(200)
    end

    f2 = function (x)
        t1 = (T(4) * x[1]^2 + T(2) * x[2] - T(11))
        t2 = (T(2) * x[1] + T(4) * x[2]^2 - T(7))
        return -T(5) + (t1^2 + t2^2) / T(200)
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        t1 = (x[1]^2 + x[2] - T(11))
        t2 = (x[1] + x[2]^2 - T(7))
        df_dx1 = (T(2) * x[1] * t1 + t2) / T(100)
        df_dx2 = (t1 + T(2) * x[2] * t2) / T(100)
        return T[df_dx1, df_dx2]
    end

    df2_dx = function (x)
        t1 = (T(4) * x[1]^2 + T(2) * x[2] - T(11))
        t2 = (T(2) * x[1] + T(4) * x[2]^2 - T(7))
        df_dx1 = (T(8) * x[1] * t1 + T(2) * t2) / T(100)
        df_dx2 = (T(2) * t1 + T(8) * x[2] * t2) / T(100)
        return T[df_dx1, df_dx2]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (fill(T(-100), n), fill(T(100), n))

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

