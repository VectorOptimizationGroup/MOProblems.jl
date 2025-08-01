"""
K. Ikeda, H. Kita and S. Kobayashi, "Failure of Pareto-based MOEAs: does non-dominated really mean near to optimal?," Proceedings of the 2001 Congress on Evolutionary Computation (IEEE Cat. No.01TH8546), Seoul, Korea (South), 2001, pp. 957-962 vol. 2. DOI: 10.1109/CEC.2001.934293.
"""

# ------------------------- IKK1 -------------------------
"""
    IKK1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = x₁²
    f₂(x) = (x₁ - 20)²
    f₃(x) = x₂²
- Bounds: [-50, 50] for each variable
- Convexity: non-convex for all objectives
"""
function IKK1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["IKK1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        return x[1]^2
    end

    f2 = function (x)
        return (x[1] - T(20))^2
    end

    f3 = function (x)
        return x[2]^2
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        return T[T(2) * x[1], T(0)]
    end

    df2_dx = function (x)
        return T[T(2) * (x[1] - T(20)), T(0)]
    end

    df3_dx = function (x)
        return T[T(0), T(2) * x[2]]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        J[3, :] = df3_dx(x)
        return J
    end

    bounds = (fill(T(-50), n), fill(T(50), n))

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