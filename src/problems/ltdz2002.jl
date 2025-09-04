"""
    LTDZ(; T::Type{<:AbstractFloat} = Float64)

Laumanns–Thiele–Deb–Zitzler (2002): Combining Convergence and Diversity in Evolutionary
Multiobjective Optimization.

Características:
- 3 variáveis, 3 objetivos
- Domínio: [0, 1]^3
- Não restrito (apenas limites de caixa)
- Jacobiana analítica disponível

Referência:
M. Laumanns, L. Thiele, K. Deb, E. Zitzler, Combining Convergence and Diversity in Evolutionary
Multiobjective Optimization, Evolutionary Computation, 10(3):263–282, 2002. DOI: 10.1162/106365602760234108
"""
function LTDZ(; T::Type{<:AbstractFloat} = Float64)
    meta = META["LTDZ"]
    n = meta[:nvar]  # 3
    m = meta[:nobj]  # 3

    # Conveniências
    halfpi = T(π/2)

    # Objetivos (baseados no código Fortran)
    # f1(x) = -3 + (1 + x3) * cos(x1 * π/2) * cos(x2 * π/2)
    # f2(x) = -3 + (1 + x3) * cos(x1 * π/2) * sin(x2 * π/2)
    # f3(x) = -3 + (1 + x3) * cos(x1 * π/2) * sin(x1 * π/2)
    f1 = x -> begin
        a = x[1] * halfpi
        b = x[2] * halfpi
        return T(-3.0) + (T(1.0) + x[3]) * cos(a) * cos(b)
    end

    f2 = x -> begin
        a = x[1] * halfpi
        b = x[2] * halfpi
        return T(-3.0) + (T(1.0) + x[3]) * cos(a) * sin(b)
    end

    f3 = x -> begin
        a = x[1] * halfpi
        return T(-3.0) + (T(1.0) + x[3]) * cos(a) * sin(a)
    end

    objectives = [f1, f2, f3]

    # Gradientes (jacobiana por linha) — replicam as fórmulas do Fortran
    df1_dx = x -> begin
        a = x[1] * halfpi
        b = x[2] * halfpi
        g = zeros(T, n)
        g[1] = -halfpi * (T(1.0) + x[3]) * sin(a) * cos(b)
        g[2] = -halfpi * (T(1.0) + x[3]) * cos(a) * sin(b)
        g[3] =  cos(a) * cos(b)
        return g
    end

    df2_dx = x -> begin
        a = x[1] * halfpi
        b = x[2] * halfpi
        g = zeros(T, n)
        g[1] = -halfpi * (T(1.0) + x[3]) * sin(a) * sin(b)
        g[2] =  halfpi * (T(1.0) + x[3]) * cos(a) * cos(b)
        g[3] =  cos(a) * sin(b)
        return g
    end

    df3_dx = x -> begin
        a = x[1] * halfpi
        cosa = cos(a); sina = sin(a)
        g = zeros(T, n)
        g[1] = halfpi * (T(1.0) + x[3]) * (cosa * cosa - sina * sina)
        g[2] = T(0)
        g[3] =  cosa * sina
        return g
    end

    gradients = [df1_dx, df2_dx, df3_dx]

    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        J[3, :] = df3_dx(x)
        return J
    end

    return MOProblem(
        n,
        m,
        objectives;
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (zeros(T, n), ones(T, n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity]
    )
end

