"""
A. Farhang-Mehr and S. Azarm, "Diversity assessment of Pareto optimal solution sets: an entropy approach," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 723-728 vol.1, DOI: 10.1109/CEC.2002.1007015.
"""

# ------------------------- FA1 -------------------------
"""
    FA1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 3 variables
- 3 objectives
- Objectives:
    f₁(x) = (1 - exp(-4x₁)) / (1 - exp(-4))
    f₂(x) = (x₂ + 1) * (1 - ((1 - exp(-4x₁)) / (x₂ + 1))^0.5)
    f₃(x) = (x₃ + 1) * (1 - ((1 - exp(-4x₁)) / (x₃ + 1))^0.1)
- Bounds: [1e-2, 1.0] for all variables
- Convexity: [non-convex, non-convex, non-convex]
"""
function FA1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["FA1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Objective functions
    f1 = x -> (T(1) - exp(-T(4) * x[1])) / (T(1) - exp(-T(4)))
    f2 = x -> (x[2] + T(1)) * (T(1) - ((T(1) - exp(-T(4) * x[1])) / (x[2] + T(1)))^T(0.5))
    f3 = x -> (x[3] + T(1)) * (T(1) - ((T(1) - exp(-T(4) * x[1])) / (x[3] + T(1)))^T(0.1))

    # Gradients (analytical Jacobian)
    df1_dx = x -> T[4 * exp(-4 * x[1]) / (1 - exp(-4)), 0, 0]
    
    df2_dx = x -> begin
        a = exp(-4 * x[1])              # exp(-4x₁)
        s = (1 - a) / (x[2] + 1)        # (1 - exp(-4x₁)) / (x₂ + 1)
        T[-2 * a * s^(-0.5),            # ∂f₂/∂x₁
          1 - 0.5 * s^0.5,              # ∂f₂/∂x₂
          0]                            # ∂f₂/∂x₃
    end

    df3_dx = x -> begin
        a = exp(-4 * x[1])              # exp(-4x₁)
        s = (1 - a) / (x[3] + 1)        # (1 - exp(-4x₁)) / (x₃ + 1)
        T[-0.4 * a * s^(-0.9),          # ∂f₃/∂x₁
          0,                            # ∂f₃/∂x₂
          1 - 0.9 * s^0.1]              # ∂f₃/∂x₃
    end

    # Jacobian (m × n) built from gradient rows
    jacobian = x -> begin
        J = zeros(T, m, n)  # m rows (objectives) × n cols (variables)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        J[3, :] = df3_dx(x)
        return J
    end

    bounds = (fill(T(1e-2), n), fill(T(1.0), n))

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
        convexity = meta[:convexity]
    )
end