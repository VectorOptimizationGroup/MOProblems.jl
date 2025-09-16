"""
Socha, K., & Kisiel-Dorohinicki, M. (2002).
Agent-based evolutionary multiobjective optimisation.
Proceedings of the CEC 2002 (Vol. 1, pp. 109–114). IEEE. https://doi.org/10.1109/CEC.2002.1006218
"""

# ------------------------- SK1 -------------------------
"""
    SK1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `SK1`):
- 1 variable, 2 objectives
- Bounds: [−100, 100]
- Objectives:
    f₁(x) = x₁⁴ + 3x₁³ − 10x₁² − 10x₁ − 10
    f₂(x) = 0.5x₁⁴ − 2x₁³ − 10x₁² + 10x₁ − 5
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex]
"""
function SK1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SK1"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]^4 + T(3) * x[1]^3 - T(10) * x[1]^2 - T(10) * x[1] - T(10)
    f2 = x -> T(0.5) * x[1]^4 - T(2) * x[1]^3 - T(10) * x[1]^2 + T(10) * x[1] - T(5)

    df1 = x -> T[
        T(4) * x[1]^3 + T(9) * x[1]^2 - T(20) * x[1] - T(10),
    ]

    df2 = x -> T[
        T(2) * x[1]^3 - T(6) * x[1]^2 - T(20) * x[1] + T(10),
    ]

    jac = x -> [df1(x)'; df2(x)']

    bounds = (fill(T(-100), n), fill(T(100), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end

# ------------------------- SK2 -------------------------
"""
    SK2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `SK2`):
- 4 variables, 2 objectives
- Bounds: [−10, 10]^4
- Objectives:
    f₁(x) = (x₁ − 2)² + (x₂ + 3)² + (x₃ − 5)² + (x₄ − 4)² − 5
    f₂(x) = −[sin(x₁) + sin(x₂) + sin(x₃) + sin(x₄)] / (1 + (x₁² + x₂² + x₃² + x₄²) / 100)
- Analytical Jacobian available
- Convexity flags: [:strictly_convex, :non_convex]
"""
function SK2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SK2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = function (x)
        return (x[1] - T(2))^2 + (x[2] + T(3))^2 + (x[3] - T(5))^2 + (x[4] - T(4))^2 - T(5)
    end

    f2 = function (x)
        s = sin(x[1]) + sin(x[2]) + sin(x[3]) + sin(x[4])
        denom = T(1) + (x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2) / T(100)
        return -s / denom
    end

    df1 = x -> T[
        T(2) * (x[1] - T(2)),
        T(2) * (x[2] + T(3)),
        T(2) * (x[3] - T(5)),
        T(2) * (x[4] - T(4)),
    ]

    df2 = function (x)
        denom = T(1) + (x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2) / T(100)
        numer = sin(x[1]) + sin(x[2]) + sin(x[3]) + sin(x[4])
        common = numer / T(50)
        return T[
            (-cos(x[1]) * denom + common * x[1]) / denom^2,
            (-cos(x[2]) * denom + common * x[2]) / denom^2,
            (-cos(x[3]) * denom + common * x[3]) / denom^2,
            (-cos(x[4]) * denom + common * x[4]) / denom^2,
        ]
    end

    jac = x -> [df1(x)'; df2(x)']

    bounds = (fill(T(-10), n), fill(T(10), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end

