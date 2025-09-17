"""
Valenzuela-Rendón, M., & Uresti-Charre, E. (1997).
A nongenerational genetic algorithm for multiobjective optimization.
Proceedings of the 7th International Conference on Genetic Algorithms, 658-665.

Nota: As expressões explícitas usadas aqui foram extraídas do compêndio de Huband, S., Hingston, P.,
Barone, L., & While, L. (2006). "A review of multiobjective test problems and a scalable test
problem toolkit," IEEE Transactions on Evolutionary Computation, 10(5), 477-506.
https://doi.org/10.1109/TEVC.2005.861417, pois o texto original não apresenta as fórmulas de maneira
verificável.
"""

# ------------------------- VU1 -------------------------
"""
    VU1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (referência primária Valenzuela-Rendón & Uresti-Charre, 1997; fórmulas reportadas por Huband et al., 2006):
- 2 variables, 2 objectives
- Bounds: [-3, 3]^2
- Objectives:
    f1(x) = 1 / (x1^2 + x2^2 + 1)
    f2(x) = x1^2 + 3x2^2 + 1
- Analytical Jacobian available
- Convexity flags: [:non_convex, :strictly_convex]
"""
function VU1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["VU1"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> begin
        den = x[1]^2 + x[2]^2 + one(T)
        T(1) / den
    end
    f2 = x -> x[1]^2 + T(3) * x[2]^2 + one(T)

    df1 = x -> begin
        den = x[1]^2 + x[2]^2 + one(T)
        coeff = -T(2) / den^2
        T[coeff * x[1], coeff * x[2]]
    end
    df2 = x -> T[T(2) * x[1], T(6) * x[2]]

    jac = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1(x)
        J[2, :] = df2(x)
        J
    end

    bounds = (fill(T(-3), n), fill(T(3), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end

# ------------------------- VU2 -------------------------
"""
    VU2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (referência primária Valenzuela-Rendón & Uresti-Charre, 1997; fórmulas reportadas por Huband et al., 2006):
- 2 variables, 2 objectives
- Bounds: [-3, 3]^2
- Objectives:
    f1(x) = x1 + x2 + 1
    f2(x) = x1^2 + 2x2 - 1
- Analytical Jacobian available
- Convexity flags: [:non_convex, :strictly_convex]
"""
function VU2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["VU2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1] + x[2] + one(T)
    f2 = x -> x[1]^2 + T(2) * x[2] - one(T)

    df1 = x -> T[one(T), one(T)]
    df2 = x -> T[T(2) * x[1], T(2)]

    jac = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1(x)
        J[2, :] = df2(x)
        J
    end

    bounds = (fill(T(-3), n), fill(T(3), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end
