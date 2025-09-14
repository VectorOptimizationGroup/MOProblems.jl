"""
    SP1(; T::Type{<:AbstractFloat}=Float64)

Two-objective problem (Sefrioui & Perlaux, 2000).

Characteristics from Fortran reference:
- 2 variables
- 2 objectives
- Bounds: [-100, 100]^2
- Both objectives strictly convex

Reference: Sefrioui, M., & Perlaux, J. (2000). Nash genetic algorithms: examples and applications. In Proceedings of CEC 2000, 509–516. DOI: 10.1109/CEC.2000.870339.
"""
function SP1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SP1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Objectives (from Souza-DR/tempfunc.f90, problem 'SP1')
    f1 = x -> (x[1] - T(1))^2 + (x[1] - x[2])^2
    f2 = x -> (x[2] - T(3))^2 + (x[1] - x[2])^2

    # Gradients (Jacobian by rows)
    df1 = x -> T[
        T(2) * (x[1] - T(1)) + T(2) * (x[1] - x[2]),
        -T(2) * (x[1] - x[2]),
    ]

    df2 = x -> T[
        T(2) * (x[1] - x[2]),
        T(2) * (x[2] - T(3)) - T(2) * (x[1] - x[2]),
    ]

    jac = x -> [df1(x)'; df2(x)']

    # Bounds from Fortran: l = -1.0d2, u = 1.0d2
    bounds = (fill(T(-100), n), fill(T(100), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end
