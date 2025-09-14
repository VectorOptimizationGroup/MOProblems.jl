"""
Shim, M.-B., Suh, M.-W., Furukawa, T., Yagawa, G., Yoshimura, S. (2002).
Pareto-based continuous evolutionary algorithms for multiobjective optimization.
Engineering Computations, 19(1), 22–48. https://doi.org/10.1108/02644400210413649
"""
#TODO: Add SSFYY1, SSFYY3 and SSFYY4 problems

# ------------------------- SSFYY2 -------------------------
"""
    SSFYY2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 1 variable, 2 objectives
- Bounds: [−100, 100]
- Objectives (per Fortran reference implementation):
    f₁(x) = 10 + x₁² − 10 cos(π x₁ / 2)
    f₂(x) = (x₁ − 4)²
- Analytical Jacobian available
- Convexity: [:non_convex, :strictly_convex]
"""
function SSFYY2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SSFYY2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> T(10) + x[1]^2 - T(10) * cos(π * x[1] / T(2))
    f2 = x -> (x[1] - T(4))^2

    df1 = x -> T[T(2) * x[1] + T(5) * π * sin(π * x[1] / T(2))]
    df2 = x -> T[T(2) * (x[1] - T(4))]

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
