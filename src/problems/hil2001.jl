"""
C. Hillermeier, "Generalized Homotopy Approach to Multiobjective Optimization," Journal of Optimization Theory and Applications, vol. 110, pp. 557–583, 2001. DOI: 10.1023/A:1017536311488.
"""

# ------------------------- HIL1 -------------------------
"""
    HIL1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = cos(a) * b
    f₂(x) = sin(a) * b
    where:
    a = (2π/360) * (45 + 40*sin(2π*x₁) + 25*sin(2π*x₂))
    b = 1 + 0.5*cos(2π*x₁)
- Bounds: [0, 1] for each variable
- Convexity: non-convex for both objectives
"""
function Hil1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Hil1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Constants (sem `const` em escopo de função)
    PI = T(π)
    TWO_PI = T(2) * PI

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        # Calculate a and b as in Fortran code
        a = T(2) * PI / T(360) * (T(45) + T(40) * sin(TWO_PI * x[1]) + T(25) * sin(TWO_PI * x[2]))
        b = T(1) + T(0.5) * cos(TWO_PI * x[1])
        return cos(a) * b
    end

    f2 = function (x)
        # Calculate a and b as in Fortran code
        a = T(2) * PI / T(360) * (T(45) + T(40) * sin(TWO_PI * x[1]) + T(25) * sin(TWO_PI * x[2]))
        b = T(1) + T(0.5) * cos(TWO_PI * x[1])
        return sin(a) * b
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        # Pre-compute common terms
        a = T(2) * PI / T(360) * (T(45) + T(40) * sin(TWO_PI * x[1]) + T(25) * sin(TWO_PI * x[2]))
        b = T(1) + T(0.5) * cos(TWO_PI * x[1])
        
        # Derivatives from Fortran code
        df_dx1 = -T(160) * PI^2 / T(360) * cos(TWO_PI * x[1]) * sin(a) * b - PI * sin(TWO_PI * x[1]) * cos(a)
        df_dx2 = -T(100) * PI^2 / T(360) * cos(TWO_PI * x[2]) * sin(a) * b
        
        return T[df_dx1, df_dx2]
    end

    df2_dx = function (x)
        # Pre-compute common terms
        a = T(2) * PI / T(360) * (T(45) + T(40) * sin(TWO_PI * x[1]) + T(25) * sin(TWO_PI * x[2]))
        b = T(1) + T(0.5) * cos(TWO_PI * x[1])
        
        # Derivatives from Fortran code
        df_dx1 = T(160) * PI^2 / T(360) * cos(TWO_PI * x[1]) * cos(a) * b - PI * sin(TWO_PI * x[1]) * sin(a)
        df_dx2 = T(100) * PI^2 / T(360) * cos(TWO_PI * x[2]) * cos(a) * b
        
        return T[df_dx1, df_dx2]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (zeros(T, n), ones(T, n))

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