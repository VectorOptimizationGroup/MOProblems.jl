"""
Preuss, M., Naujoks, B., Rudolph, G. (2006). Pareto Set and EMOA Behavior for Simple Multimodal
Multiobjective Functions. In: Runarsson, T.P., Beyer, H.-G., Burke, E., Merelo-Guervós, J.J.,
Whitley, L.D., Yao, X. (eds) Parallel Problem Solving from Nature - PPSN IX. Lecture Notes in
Computer Science, vol 4193. Springer, Berlin, Heidelberg. https://doi.org/10.1007/11844297_52
"""

# ------------------------- PNR -------------------------
"""
    PNR(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁⁴ + x₂⁴ − x₁² + x₂² − 10·x₁·x₂ + 20 #TODO: Rever o paper para adicionar os parametros faltantes
    f₂(x) = x₁² + x₂²
- Bounds: [−2, 2] for each variable
- Convexity: f₁ non-convex, f₂ strictly convex
"""
function PNR(; T::Type{<:AbstractFloat}=Float64)
    meta = META["PNR"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        x1, x2 = x[1], x[2]
        return x1^4 + x2^4 - x1^2 + x2^2 - T(10)*x1*x2 + T(20)
    end

    f2 = function (x)
        x1, x2 = x[1], x[2]
        return x1^2 + x2^2
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        x1, x2 = x[1], x[2]
        df_dx1 = T(4)*x1^3 - T(2)*x1 - T(10)*x2
        df_dx2 = T(4)*x2^3 + T(2)*x2 - T(10)*x1
        return T[df_dx1, df_dx2]
    end

    df2_dx = function (x)
        x1, x2 = x[1], x[2]
        return T[ T(2)*x1, T(2)*x2 ]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (fill(T(-2), n), fill(T(2), n))

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

