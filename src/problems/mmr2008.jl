"""
    MMR1, MMR2, MMR3, MMR4

Test problems from:
E. Miglierina, E. Molho, M.C. Recchioni (2008),
"Box-constrained multi-objective optimization: A gradient-like method without “a priori” scalarization",
European Journal of Operational Research, 188(3), 662–682.
https://doi.org/10.1016/j.ejor.2007.05.015
"""

# ------------------------- MMR1 -------------------------
"""
    MMR1()

Características:
- n = 2 variáveis, m = 2 objetivos
- Domínio: x₁ ∈ [0.1, 1.0], x₂ ∈ [0.0, 1.0]
- Objetivos:
  - f₁(x) = x₁
  - f₂(x) = [2 - 0.8 e^{-((x₂-0.6)/0.4)^2} - e^{-((x₂-0.2)/0.04)^2}] / x₁
- Convexidade: [:convex, :non_convex]
"""
function MMR1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MMR1"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]
    f2 = x -> begin
        t1 = exp(-((x[2] - T(0.6)) / T(0.4))^2)
        t2 = exp(-((x[2] - T(0.2)) / T(0.04))^2)
        g = T(2.0) - T(0.8) * t1 - t2
        return g / x[1]
    end

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = one(T)
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        t1 = exp(-((x[2] - T(0.6)) / T(0.4))^2)
        t2 = exp(-((x[2] - T(0.2)) / T(0.04))^2)
        g = T(2.0) - T(0.8) * t1 - t2
        grad[1] = - g / (x[1]^2)
        grad[2] = (T(10.0) * t1 * (x[2] - T(0.6)) + T(1250.0) * t2 * (x[2] - T(0.2))) / x[1]
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    lb = T[0.1, 0.0]
    ub = T[1.0, 1.0]

    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = true,
        bounds = (lb, ub),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- MMR2 -------------------------
"""
    MMR2()

Características:
- n = 2 variáveis, m = 2 objetivos
- Domínio: [0, 1]^2
- Objetivos:
  - f₁(x) = x₁
  - f₂(x) = (1 - (x₁/a)^2 - (x₁/a) sin(8π x₁)) a, com a = 1 + 10 x₂
- Convexidade: [:convex, :non_convex]
"""
function MMR2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MMR2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]
    f2 = x -> begin
        a = T(1.0) + T(10.0) * x[2]
        faux = x[1] / a
        return (T(1.0) - faux^2 - faux * sin(T(8.0) * pi * x[1])) * a
    end

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = one(T)
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        a = T(1.0) + T(10.0) * x[2]
        faux = x[1] / a
        # ∂f₂/∂x₁
        g1 = - T(2.0) * faux / a - sin(T(8.0) * pi * x[1]) / a - T(8.0) * pi * faux * cos(T(8.0) * pi * x[1])
        grad[1] = g1 * a
        # ∂f₂/∂x₂
        grad[2] = T(10.0) * (T(1.0) - faux^2 - faux * sin(T(8.0) * pi * x[1])) +
                  a * (T(20.0) * faux * x[1] / (a^2) + T(10.0) / (a^2) * x[1] * sin(T(8.0) * pi * x[1]))
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    lb = T[0.0, 0.0]
    ub = T[1.0, 1.0]

    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = true,
        bounds = (lb, ub),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- MMR3 -------------------------
"""
    MMR3()

Características:
- n = 2 variáveis, m = 2 objetivos
- Domínio: x₁, x₂ ∈ [-1, 1]
- Objetivos:
  - f₁(x) = x₁³
  - f₂(x) = (x₂ - x₁)³
- Convexidade: [:non_convex, :non_convex]
"""
function MMR3(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MMR3"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]^3
    f2 = x -> (x[2] - x[1])^3

    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(3.0) * x[1]^2
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        t = (x[2] - x[1])^2
        grad[1] = -T(3.0) * t
        grad[2] =  T(3.0) * t
        return grad
    end

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    lb = T[-1.0, -1.0]
    ub = T[ 1.0,  1.0]

    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = true,
        bounds = (lb, ub),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- MMR4 -------------------------
"""
    MMR4()

Características:
- n = 3 variáveis, m = 2 objetivos
- Domínio: [0, 4]^3
- Objetivos:
  - f₁(x) = x₁ - 2x₂ - x₃ - 36 / (2x₁ + x₂ + 2x₃ + 1)
  - f₂(x) = -3x₁ + x₂ - x₃
- Convexidade: [:non_convex, :convex]
"""
function MMR4(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MMR4"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> begin
        den = T(2.0) * x[1] + x[2] + T(2.0) * x[3] + T(1.0)
        return x[1] - T(2.0) * x[2] - x[3] - T(36.0) / den
    end
    f2 = x -> -T(3.0) * x[1] + x[2] - x[3]

    df1_dx = x -> begin
        grad = zeros(T, n)
        t = (T(2.0) * x[1] + x[2] + T(2.0) * x[3] + T(1.0))^2
        grad[1] = T(1.0) + T(72.0) / t
        grad[2] = -T(2.0) + T(36.0) / t
        grad[3] = -T(1.0) + T(72.0) / t
        return grad
    end

    df2_dx = x -> T[-3.0, 1.0, -1.0]

    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    lb = T[0.0, 0.0, 0.0]
    ub = T[4.0, 4.0, 4.0]

    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = true,
        bounds = (lb, ub),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

