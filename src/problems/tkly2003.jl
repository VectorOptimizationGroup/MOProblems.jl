"""
Tan, K. C., Khor, E. F., Lee, T. H., & Yang, Y. J. (2003).
A Tabu-Based Exploratory Evolutionary Algorithm for Multiobjective Optimization.
Artificial Intelligence Review, 19(3), 231-260. https://doi.org/10.1023/A:1022863019997
"""

# ------------------------- TKLY1 -------------------------
"""
    TKLY1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `TKLY1`):
- 4 variables, 2 objectives
- Bounds: x1 in [0.1, 1], x2, x3, x4 in [0, 1]
- Objectives:
    f1(x) = x1
    f2(x) = A(x2) * A(x3) * A(x4) / x1,
    where A(z) = 2 - exp(-((z - 0.1) / 0.004)^2) - 0.8 * exp(-((z - 0.9) / 0.4)^2)
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex]
"""
function TKLY1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["TKLY1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Auxiliary functions for A(z) and its derivative (from Fortran implementation)
    local function A(z)
        u1 = (z - T(0.1)) / T(4e-3)
        u2 = (z - T(0.9)) / T(4e-1)
        return T(2) - exp(-u1^2) - T(0.8) * exp(-u2^2)
    end

    local function dA(z)
        u1 = (z - T(0.1)) / T(4e-3)
        u2 = (z - T(0.9)) / T(4e-1)
        term1 = T(500) * exp(-u1^2) * u1
        term2 = T(4) * exp(-u2^2) * u2
        return term1 + term2
    end

    f1 = x -> x[1]
    f2 = function (x)
        return A(x[2]) * A(x[3]) * A(x[4]) / x[1]
    end

    df1 = x -> T[
        one(T),
        zero(T),
        zero(T),
        zero(T),
    ]

    df2 = function (x)
        a2 = A(x[2])
        a3 = A(x[3])
        a4 = A(x[4])
        numerator = a2 * a3 * a4
        denom = x[1]
        return T[
            -numerator / denom^2,
            dA(x[2]) * a3 * a4 / denom,
            a2 * dA(x[3]) * a4 / denom,
            a2 * a3 * dA(x[4]) / denom,
        ]
    end

    jac = x -> [df1(x)'; df2(x)']

    lower = vcat(T(0.1), fill(T(0), n - 1))
    upper = vcat(T(1), fill(T(1), n - 1))
    bounds = (Vector{T}(lower), Vector{T}(upper))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end
