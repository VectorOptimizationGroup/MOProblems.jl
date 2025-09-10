"""
Stadler, W., Dauer, J. Multicriteria Optimization in Engineering: A Tutorial and Survey.
In: Kamat, M.P. (ed.) Structural Optimization: Status and Promise, Progress in Aeronautics and Astronautics,
vol. 150, pp. 209–249. AIAA, Reston (1992). doi:10.2514/5.9781600866234.0209.0249
"""

# ------------------------- SD -------------------------
"""
    SD(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 4 variables, 2 objectives
- Bounds: x₁∈[1,3], x₂∈[√2,3], x₃∈[√2,3], x₄∈[1,3]
- Objectives:
    f₁(x) = 2x₁ + √2(x₂ + x₃) + x₄ #TODO: Rever o paper para adicionar os parametros faltantes
    f₂(x) = 2/x₁ + 2√2/x₂ + 2√2/x₃ + 2/x₄
- Gradients:
    ∇f₁ = [2, √2, √2, 1]
    ∇f₂ = [−2/x₁², −2√2/x₂², −2√2/x₃², −2/x₄²]
- Convexity: [non-convex, strictly convex]
"""
function SD(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SD"]
    n = meta[:nvar]
    m = meta[:nobj]

    s2 = sqrt(T(2))

    # Objectives
    f1 = function (x)
        return T(2)*x[1] + s2*(x[2] + x[3]) + x[4]
    end

    f2 = function (x)
        return T(2)/x[1] + T(2)*s2/x[2] + T(2)*s2/x[3] + T(2)/x[4]
    end

    # Gradients
    df1_dx = function (x)
        return T[ T(2), s2, s2, T(1) ]
    end

    df2_dx = function (x)
        return T[ -T(2)/(x[1]^2), -T(2)*s2/(x[2]^2), -T(2)*s2/(x[3]^2), -T(2)/(x[4]^2) ]
    end

    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    l = T[1, sqrt(T(2)), sqrt(T(2)), 1]
    u = T[3, 3, 3, 3]
    bounds = (l, u)

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

