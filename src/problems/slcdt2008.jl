"""
Schütze, O., Laumanns, M., Coello Coello, C.A., Dellnitz, M., Talbi, E.-G. (2008).
Convergence of stochastic search algorithms to finite size pareto set approximations.
Journal of Global Optimization 41(4): 559–577. https://doi.org/10.1007/s10898-007-9265-7
"""

# ------------------------- SLCDT1 -------------------------
"""
    SLCDT1(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 2 variables, 2 objectives
- Bounds: [−1.5, 1.5]^2
- Objectives:
    f₁(x) = 0.5[ √(1+(x₁+x₂)²) + √(1+(x₁−x₂)²) + x₁ − x₂ ] + 0.85·exp(−(x₁+x₂)²) #TODO: Rever o paper para adicionar os parametros faltantes
    f₂(x) = 0.5[ √(1+(x₁+x₂)²) + √(1+(x₁−x₂)²) − x₁ + x₂ ] + 0.85·exp(−(x₁+x₂)²)
"""
function SLCDT1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SLCDT1"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = function (x)
        x1, x2 = x[1], x[2]
        s = x1 + x2
        d = x1 - x2
        return T(0.5) * (sqrt(T(1) + s^2) + sqrt(T(1) + d^2) + x1 - x2) + T(0.85) * exp(-(s^2))
    end

    f2 = function (x)
        x1, x2 = x[1], x[2]
        s = x1 + x2
        d = x1 - x2
        return T(0.5) * (sqrt(T(1) + s^2) + sqrt(T(1) + d^2) - x1 + x2) + T(0.85) * exp(-(s^2))
    end

    df1_dx = function (x)
        x1, x2 = x[1], x[2]
        s = x1 + x2
        d = x1 - x2
        t1 = s / sqrt(T(1) + s^2)
        t2 = d / sqrt(T(1) + d^2)
        common = -T(2) * T(0.85) * s * exp(-(s^2))
        g1 = T(0.5) * (t1 + t2 + T(1)) + common
        g2 = T(0.5) * (t1 - t2 - T(1)) + common
        return T[g1, g2]
    end

    df2_dx = function (x)
        x1, x2 = x[1], x[2]
        s = x1 + x2
        d = x1 - x2
        t1 = s / sqrt(T(1) + s^2)
        t2 = d / sqrt(T(1) + d^2)
        common = -T(2) * T(0.85) * s * exp(-(s^2))
        g1 = T(0.5) * (t1 + t2 - T(1)) + common
        g2 = T(0.5) * (t1 - t2 + T(1)) + common
        return T[g1, g2]
    end

    jacobian1 = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds1 = (fill(T(-1.5), n), fill(T(1.5), n))

    prob1 = MOProblem(
        n, m, [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds1,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian1,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity],
    )
    return prob1
end


# ------------------------- SLCDT2 -------------------------
"""
    SLCDT2(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 10 variables, 3 objectives
- Bounds: [−1, 1]^n
- Objectives (per Fortran reference implementation):
    f₁(x) = (x₁−1)⁴ + Σ_{i=2..n} (xᵢ−1)²
    f₂(x) = (x₂+1)⁴ + Σ_{i≠2} (xᵢ+1)²
    f₃(x) = (x₃−1)⁴ + Σ_{i≠3} (xᵢ − (−1)^{i+1})²
"""
function SLCDT2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["SLCDT2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = function (x)
        s = (x[1] - T(1))^4
        for i in 2:n
            s += (x[i] - T(1))^2
        end
        return s
    end

    f2 = function (x)
        s = (x[2] + T(1))^4
        for i in 1:n
            if i != 2
                s += (x[i] + T(1))^2
            end
        end
        return s
    end

    f3 = function (x)
        s = (x[3] - T(1))^4
        for i in 1:n
            if i != 3
                alt = isodd(i) ? T(1) : T(-1)   # (-1)^(i+1)
                s += (x[i] - alt)^2
            end
        end
        return s
    end

    df1_dx = function (x)
        g = zeros(T, n)
        g[1] = T(4) * (x[1] - T(1))^3
        for i in 2:n
            g[i] = T(2) * (x[i] - T(1))
        end
        return g
    end

    df2_dx = function (x)
        g = zeros(T, n)
        g[2] = T(4) * (x[2] + T(1))^3
        for i in 1:n
            if i != 2
                g[i] = T(2) * (x[i] + T(1))
            end
        end
        return g
    end

    df3_dx = function (x)
        g = zeros(T, n)
        g[3] = T(4) * (x[3] - T(1))^3
        for i in 1:n
            if i != 3
                alt = isodd(i) ? T(1) : T(-1)   # (-1)^(i+1)
                g[i] = T(2) * (x[i] - alt)
            end
        end
        return g
    end

    jacobian2 = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        J[3, :] = df3_dx(x)
        return J
    end

    bounds2 = (fill(T(-1), n), fill(T(1), n))

    prob2 = MOProblem(
        n, m, [f1, f2, f3];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = bounds2,
        has_jacobian = meta[:has_jacobian],
        jacobian = jacobian2,
        jacobian_by_row = [df1_dx, df2_dx, df3_dx],
        convexity = meta[:convexity],
    )
    return prob2
end

