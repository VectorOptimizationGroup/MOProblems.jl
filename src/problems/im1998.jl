"""
H. Ishibuchi and T. Murata, "A multi-objective genetic local search algorithm and its application to flowshop scheduling," in IEEE Transactions on Systems, Man, and Cybernetics, Part C (Applications and Reviews), vol. 28, no. 3, pp. 392-403, Aug. 1998, doi: 10.1109/5326.704576.
"""

# ------------------------- IM1 -------------------------
"""
    IM1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 2.0 * sqrt(x₁)
    f₂(x) = x₁ * (1.0 - x₂) + 5.0
- Bounds: x₁ ∈ [1.0, 4.0], x₂ ∈ [1.0, 2.0]
- Convexity: non-convex for both objectives
"""
function IM1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["IM1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        return T(2.0) * sqrt(x[1])
    end

    f2 = function (x)
        return x[1] * (T(1.0) - x[2]) + T(5.0)
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        return T[T(1.0) / sqrt(x[1]), T(0.0)]
    end

    df2_dx = function (x)
        return T[T(1.0) - x[2], -x[1]]
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    # Bounds: x₁ ∈ [1.0, 4.0], x₂ ∈ [1.0, 2.0]
    lower = T[T(1.0), T(1.0)]
    upper = T[T(4.0), T(2.0)]
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