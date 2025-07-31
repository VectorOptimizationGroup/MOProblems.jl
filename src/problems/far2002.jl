"""
M. Farina, "A neural network based generalized response surface multiobjective evolutionary algorithm," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 956-961 vol.1, DOI: 10.1109/CEC.2002.1007054.
"""

# ------------------------- Far1 -------------------------
"""
    Far1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) =  −2·e^{15[−(x₁−0.1)² − x₂²]}
             − e^{20[−(x₁−0.6)² − (x₂−0.6)²]}
             + e^{20[−(x₁+0.6)² − (x₂−0.6)²]}
             + e^{20[−(x₁−0.6)² − (x₂+0.6)²]}
             + e^{20[−(x₁+0.6)² − (x₂+0.6)²]}
    f₂(x) =   2·e^{20[−x₁² − x₂²]}
             + e^{20[−(x₁−0.4)² − (x₂−0.6)²]}
             − e^{20[−(x₁+0.5)² − (x₂−0.7)²]}
             − e^{20[−(x₁−0.5)² − (x₂+0.7)²]}
             + e^{20[−(x₁+0.4)² − (x₂+0.8)²]}
- Bounds: [−1, 1] for each variable
- Convexity: non-convex for both objectives
"""
function Far1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Far1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Constantes locais (sem `const` em escopo de função)
    C15 = T(15)
    C20 = T(20)

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        x1, x2 = x[1], x[2]
        term1 = -T(2) * exp( C15 * ( -((x1 - T(0.1))^2 + x2^2) ) )
        term2 = -exp( C20 * ( -((x1 - T(0.6))^2 + (x2 - T(0.6))^2) ) )
        term3 =  exp( C20 * ( -((x1 + T(0.6))^2 + (x2 - T(0.6))^2) ) )
        term4 =  exp( C20 * ( -((x1 - T(0.6))^2 + (x2 + T(0.6))^2) ) )
        term5 =  exp( C20 * ( -((x1 + T(0.6))^2 + (x2 + T(0.6))^2) ) )
        return term1 + term2 + term3 + term4 + term5
    end

    f2 = function (x)
        x1, x2 = x[1], x[2]
        term1 =  T(2) * exp( C20 * ( -(x1^2 + x2^2) ) )
        term2 =  exp( C20 * ( -((x1 - T(0.4))^2 + (x2 - T(0.6))^2) ) )
        term3 = -exp( C20 * ( -((x1 + T(0.5))^2 + (x2 - T(0.7))^2) ) )
        term4 = -exp( C20 * ( -((x1 - T(0.5))^2 + (x2 + T(0.7))^2) ) )
        term5 =  exp( C20 * ( -((x1 + T(0.4))^2 + (x2 + T(0.8))^2) ) )
        return term1 + term2 + term3 + term4 + term5
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        x1, x2 = x[1], x[2]
        # Pre-compute exponentials
        e1 = exp( C15 * ( -((x1 - T(0.1))^2 + x2^2) ) )
        e2 = exp( C20 * ( -((x1 - T(0.6))^2 + (x2 - T(0.6))^2) ) )
        e3 = exp( C20 * ( -((x1 + T(0.6))^2 + (x2 - T(0.6))^2) ) )
        e4 = exp( C20 * ( -((x1 - T(0.6))^2 + (x2 + T(0.6))^2) ) )
        e5 = exp( C20 * ( -((x1 + T(0.6))^2 + (x2 + T(0.6))^2) ) )

        # Derivatives
        df_dx1 =  T(60)*(x1 - T(0.1)) * e1 +
                  T(40)*(x1 - T(0.6)) * e2 -
                  T(40)*(x1 + T(0.6)) * e3 -
                  T(40)*(x1 - T(0.6)) * e4 -
                  T(40)*(x1 + T(0.6)) * e5

        df_dx2 =  T(60)*x2            * e1 +
                  T(40)*(x2 - T(0.6)) * e2 -
                  T(40)*(x2 - T(0.6)) * e3 -
                  T(40)*(x2 + T(0.6)) * e4 -
                  T(40)*(x2 + T(0.6)) * e5
        return T[df_dx1, df_dx2]
    end

    df2_dx = function (x)
        x1, x2 = x[1], x[2]
        # Pre-compute exponentials
        e1 = exp( C20 * ( -(x1^2 + x2^2) ) )
        e2 = exp( C20 * ( -((x1 - T(0.4))^2 + (x2 - T(0.6))^2) ) )
        e3 = exp( C20 * ( -((x1 + T(0.5))^2 + (x2 - T(0.7))^2) ) )
        e4 = exp( C20 * ( -((x1 - T(0.5))^2 + (x2 + T(0.7))^2) ) )
        e5 = exp( C20 * ( -((x1 + T(0.4))^2 + (x2 + T(0.8))^2) ) )

        df_dx1 = -T(80)*x1            * e1 -
                  T(40)*(x1 - T(0.4)) * e2 +
                  T(40)*(x1 + T(0.5)) * e3 +
                  T(40)*(x1 - T(0.5)) * e4 -
                  T(40)*(x1 + T(0.4)) * e5

        df_dx2 = -T(80)*x2            * e1 -
                  T(40)*(x2 - T(0.6)) * e2 +
                  T(40)*(x2 - T(0.7)) * e3 +
                  T(40)*(x2 + T(0.7)) * e4 -
                  T(40)*(x2 + T(0.8)) * e5
        return T[df_dx1, df_dx2]
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