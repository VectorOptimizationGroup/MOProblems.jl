"""
    MGH9(; T::Type{<:AbstractFloat} = Float64)

Moré–Garbow–Hillstrom (1981): Testing Unconstrained Optimization Software (Gaussian residuals).

Características:
- 3 variáveis, 15 objetivos (resíduos)
- Domínio: caixa [-2, 2]^3
- Não restrito (apenas limites de caixa)
- Jacobiana analítica disponível

Referência:
J. J. Moré, B. S. Garbow, K. E. Hillstrom, Testing Unconstrained Optimization Software,
ACM Transactions on Mathematical Software, 7(1):17–41, 1981. DOI: 10.1145/355934.355936
"""
function MGH9(; T::Type{<:AbstractFloat} = Float64)
    meta = META["MGH9"]
    n = meta[:nvar]  # 3
    m = meta[:nobj]  # 15

    # Precompute t(i) and y(i) as in the Fortran reference
    t = [T((8.0 - i) / 2.0) for i in 1:m]
    y = Vector{T}(undef, m)
    for i in 1:m
        if i == 1 || i == 15
            y[i] = T(9.0e-4)
        elseif i == 2 || i == 14
            y[i] = T(4.4e-3)
        elseif i == 3 || i == 13
            y[i] = T(1.75e-2)
        elseif i == 4 || i == 12
            y[i] = T(5.4e-2)
        elseif i == 5 || i == 11
            y[i] = T(1.295e-1)
        elseif i == 6 || i == 10
            y[i] = T(2.42e-1)
        elseif i == 7 || i == 9
            y[i] = T(3.521e-1)
        else # i == 8
            y[i] = T(3.989e-1)
        end
    end

    # Objective functions (each residual as a separate objective)
    objectives = Vector{Function}(undef, m)
    for i in 1:m
        ti = t[i]; yi = y[i]
        objectives[i] = x -> begin
            # f_i(x) = x1 * exp(-x2 * (ti - x3)^2 / 2) - yi
            z = ti - x[3]
            return x[1] * exp(-x[2] * (z * z) / T(2)) - yi
        end
    end

    # Gradients (jacobiana por linha) seguindo o Fortran
    gradients = Vector{Function}(undef, m)
    for i in 1:m
        ti = t[i]
        gradients[i] = x -> begin
            z = ti - x[3]
            e = exp(-x[2] * (z * z) / T(2))
            g = zeros(T, n)
            g[1] = e
            g[2] = -x[1] * e * (z * z) / T(2)
            g[3] = x[1] * e * x[2] * z
            return g
        end
    end

    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
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
        bounds = (fill(T(-2.0), n), fill(T(2.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity]
    )
end

#
# MGH16 (Brown and Dennis) — Moré–Garbow–Hillstrom (1981)
# 4 variáveis, 5 objetivos
# f_i(x) = (x1 + t_i x2 - exp(t_i))^2 + (x3 + x4 sin(t_i) - cos(t_i))^2,  t_i = i/5, i=1..5
#
function MGH16(; T::Type{<:AbstractFloat} = Float64)
    meta = META["MGH16"]
    n = meta[:nvar]  # 4
    m = meta[:nobj]  # 5

    # t_i = i/5, i = 1..5
    tvals = [T(i) / T(5) for i in 1:m]

    # Define objectives
    objectives = Vector{Function}(undef, m)
    for i in 1:m
        ti = tvals[i]
        objectives[i] = x -> begin
            a = x[1] + ti * x[2] - exp(ti)
            b = x[3] + x[4] * sin(ti) - cos(ti)
            return a * a + b * b
        end
    end

    # Row-wise gradients
    gradients = Vector{Function}(undef, m)
    for i in 1:m
        ti = tvals[i]
        s = sin(ti)
        gradients[i] = x -> begin
            a = x[1] + ti * x[2] - exp(ti)
            b = x[3] + x[4] * s - cos(ti)
            g = zeros(T, n)
            g[1] = T(2) * a
            g[2] = T(2) * ti * a
            g[3] = T(2) * b
            g[4] = T(2) * s * b
            return g
        end
    end

    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end

    # Bounds: x1 in [-25,25], x2,x3 in [-5,5], x4 in [-1,1]
    lx = T[-25, -5, -5, -1]
    ux = T[ 25,  5,  5,  1]

    return MOProblem(
        n,
        m,
        objectives;
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (lx, ux),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity]
    )

end

#
# MGH26 (Trigonometric) — Moré–Garbow–Hillstrom (1981)
# n = 4, m = n. For i = 1..n:
#   f_i(x) = ( n - sum_j cos(x_j) + i*(1 - cos(x_i)) - sin(x_i) )^2
#
function MGH26(; T::Type{<:AbstractFloat} = Float64)
    meta = META["MGH26"]
    n = meta[:nvar]  # 4
    m = meta[:nobj]  # 4

    # Objectives f_i
    objectives = Vector{Function}(undef, m)
    for i in 1:m
        ii = T(i)
        objectives[i] = x -> begin
            s = zero(T)
            @inbounds for k in 1:n
                s += cos(x[k])
            end
            hi = T(n) - s + ii * (T(1) - cos(x[i])) - sin(x[i])
            return hi * hi
        end
    end

    # Row-wise gradients (each objective i)
    gradients = Vector{Function}(undef, m)
    for i in 1:m
        ii = T(i)
        gradients[i] = x -> begin
            s = zero(T)
            @inbounds for k in 1:n
                s += cos(x[k])
            end
            hi = T(n) - s + ii * (T(1) - cos(x[i])) - sin(x[i])
            gaux1 = T(2) * hi
            g = zeros(T, n)
            @inbounds for k in 1:n
                g[k] = gaux1 * sin(x[k])
            end
            # Adjust for k == i
            g[i] += gaux1 * (ii * sin(x[i]) - cos(x[i]))
            return g
        end
    end

    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end

    # Bounds: all variables in [-1, 1]
    lx = fill(T(-1), n)
    ux = fill(T(1), n)

    return MOProblem(
        n,
        m,
        objectives;
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (lx, ux),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity]
    )
end

#
# MGH33 (Linear function — rank 1) — Moré–Garbow–Hillstrom (1981)
# n = 10, m = n. For i = 1..n:
#   f_i(x) = ( i * sum_{j=1}^n (j * x_j) - 1 )^2
# Gradient: ∇f_i(x) = 2 * (i * Σ j x_j - 1) * i * [1, 2, ..., n]
#
function MGH33(; T::Type{<:AbstractFloat} = Float64)
    meta = META["MGH33"]
    n = meta[:nvar]  # 10
    m = meta[:nobj]  # 10

    w = T.(collect(1:n))

    # Objectives f_i
    objectives = Vector{Function}(undef, m)
    for i in 1:m
        ii = T(i)
        objectives[i] = x -> begin
            s = dot(w, x)
            h = ii * s - T(1)
            return h * h
        end
    end

    # Row-wise gradients (each objective i)
    gradients = Vector{Function}(undef, m)
    for i in 1:m
        ii = T(i)
        gradients[i] = x -> begin
            s = dot(w, x)
            h = ii * s - T(1)
            return (T(2) * h * ii) .* w
        end
    end

    jacobian = x -> begin
        J = zeros(T, m, n)
        for i in 1:m
            J[i, :] = gradients[i](x)
        end
        return J
    end

    # Bounds: all variables in [-1, 1]
    lx = fill(T(-1), n)
    ux = fill(T(1), n)

    return MOProblem(
        n,
        m,
        objectives;
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (lx, ux),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = gradients,
        convexity = meta[:convexity]
    )
end
