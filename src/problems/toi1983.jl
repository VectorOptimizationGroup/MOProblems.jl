"""
Toint, P. L. (1983). Test problems for partially separable optimization and results for the routine PSPMIN.
Technical Report, University of Namur, Department of Mathematics, Belgium. https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf
See also: Mita, K., Fukuda, E. H., & Yamashita, N. (2019). Nonmonotone line searches for unconstrained multiobjective optimization problems. Journal of Global Optimization, 75, 63-90. https://doi.org/10.1007/s10898-019-00802-0
"""

# ------------------------- Toi4 -------------------------
"""
    Toi4(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `Toi4`):
- 4 variables, 2 objectives
- Bounds: [-2, 5]^4
- Objectives:
    f1(x) = x1^2 + x2^2 + 1
    f2(x) = 0.5 * [(x1 - x2)^2 + (x3 - x4)^2] + 1
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex]
"""
function Toi4(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Toi4"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]^2 + x[2]^2 + T(1)
    f2 = x -> T(0.5) * ((x[1] - x[2])^2 + (x[3] - x[4])^2) + T(1)

    df1 = x -> T[
        T(2) * x[1],
        T(2) * x[2],
        zero(T),
        zero(T),
    ]

    df2 = x -> T[
        x[1] - x[2],
        -(x[1] - x[2]),
        x[3] - x[4],
        -(x[3] - x[4]),
    ]

    jac = x -> [df1(x)'; df2(x)']

    bounds = (fill(T(-2), n), fill(T(5), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end

# ------------------------- Toi8 (TRIDIA) -------------------------
"""
    Toi8(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `Toi8`):
- 3 variables, 3 objectives (m = n)
- Bounds: [-1, 1]^3
- Objectives:
    f1(x) = (2x1 - 1)^2
    fi(x) = i * (2x_{i-1} - x_i)^2 for i = 2, 3
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex, :non_convex]
"""
function Toi8(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Toi8"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> (T(2) * x[1] - T(1))^2
    f_row = Vector{Function}(undef, m)
    f_row[1] = f1
    for idx in 2:m
        f_row[idx] = let idx = idx
            x -> T(idx) * (T(2) * x[idx - 1] - x[idx])^2
        end
    end

    jac_rows = Vector{Function}(undef, m)
    jac_rows[1] = x -> begin
        g = zeros(T, n)
        g[1] = T(4) * (T(2) * x[1] - T(1))
        g
    end
    for idx in 2:m
        jac_rows[idx] = let idx = idx
            x -> begin
                g = zeros(T, n)
                diff = T(2) * x[idx - 1] - x[idx]
                g[idx - 1] = T(4) * T(idx) * diff
                g[idx] = -T(2) * T(idx) * diff
                g
            end
        end
    end

    jac = x -> begin
        J = zeros(T, m, n)
        for idx in 1:m
            J[idx, :] = jac_rows[idx](x)
        end
        J
    end

    bounds = (fill(T(-1), n), fill(T(1), n))

    return MOProblem(
        n, m, f_row;
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = jac_rows,
        convexity = meta[:convexity],
    )
end

# ------------------------- Toi9 (Shifted TRIDIA) -------------------------
"""
    Toi9(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `Toi9`):
- 4 variables, 4 objectives (m = n)
- Bounds: [-1, 1]^4
- Objectives:
    f1(x) = (2x1 - 1)^2 + x2^2
    fi(x) = i * (2x_{i-1} - x_i)^2 - (i - 1) * x_{i-1}^2 + i * x_i^2 for 2 <= i < n
    fn(x) = n * (2x_{n-1} - x_n)^2 - (n - 1) * x_{n-1}^2
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex, :non_convex, :non_convex]
"""
function Toi9(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Toi9"]
    n = meta[:nvar]
    m = meta[:nobj]

    f_list = Vector{Function}(undef, m)
    f_list[1] = x -> (T(2) * x[1] - T(1))^2 + x[2]^2
    for idx in 2:(m - 1)
        f_list[idx] = let idx = idx
            x -> begin
                diff = T(2) * x[idx - 1] - x[idx]
                T(idx) * diff^2 - (T(idx) - T(1)) * x[idx - 1]^2 + T(idx) * x[idx]^2
            end
        end
    end
    f_list[m] = x -> begin
        diff = T(2) * x[n - 1] - x[n]
        T(n) * diff^2 - (T(n) - T(1)) * x[n - 1]^2
    end

    jac_rows = Vector{Function}(undef, m)
    jac_rows[1] = x -> begin
        g = zeros(T, n)
        g[1] = T(4) * (T(2) * x[1] - T(1))
        g[2] = T(2) * x[2]
        g
    end
    for idx in 2:(m - 1)
        jac_rows[idx] = let idx = idx
            x -> begin
                g = zeros(T, n)
                diff = T(2) * x[idx - 1] - x[idx]
                g[idx - 1] = T(4) * T(idx) * diff - T(2) * (T(idx) - T(1)) * x[idx - 1]
                g[idx] = -T(2) * T(idx) * diff + T(2) * T(idx) * x[idx]
                g
            end
        end
    end
    jac_rows[m] = x -> begin
        g = zeros(T, n)
        diff = T(2) * x[n - 1] - x[n]
        g[n - 1] = T(4) * T(n) * diff - T(2) * (T(n) - T(1)) * x[n - 1]
        g[n] = -T(2) * T(n) * diff
        g
    end

    jac = x -> begin
        J = zeros(T, m, n)
        for idx in 1:m
            J[idx, :] = jac_rows[idx](x)
        end
        J
    end

    bounds = (fill(T(-1), n), fill(T(1), n))

    return MOProblem(
        n, m, f_list;
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = jac_rows,
        convexity = meta[:convexity],
    )
end

# ------------------------- Toi10 (Rosenbrock) -------------------------
"""
    Toi10(; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary (from Souza-DR/tempfunc.f90, problem `Toi10`):
- 4 variables, 3 objectives (m = n - 1)
- Bounds: [-2, 2]^4
- Objectives:
    fi(x) = 100 * (x_{i+1} - x_i^2)^2 + (x_{i+1} - 1)^2 for i = 1, 2, 3
- Analytical Jacobian available
- Convexity flags: [:non_convex, :non_convex, :non_convex]
"""
function Toi10(; T::Type{<:AbstractFloat}=Float64)
    meta = META["Toi10"]
    n = meta[:nvar]
    m = meta[:nobj]

    f_rows = Vector{Function}(undef, m)
    for idx in 1:m
        f_rows[idx] = let idx = idx
            x -> begin
                diff = x[idx + 1] - x[idx]^2
                T(100) * diff^2 + (x[idx + 1] - T(1))^2
            end
        end
    end

    jac_rows = Vector{Function}(undef, m)
    for idx in 1:m
        jac_rows[idx] = let idx = idx
            x -> begin
                g = zeros(T, n)
                diff = x[idx + 1] - x[idx]^2
                g[idx] = -T(400) * diff * x[idx]
                g[idx + 1] = T(200) * diff + T(2) * (x[idx + 1] - T(1))
                g
            end
        end
    end

    jac = x -> begin
        J = zeros(T, m, n)
        for idx in 1:m
            J[idx, :] = jac_rows[idx](x)
        end
        J
    end

    bounds = (fill(T(-2), n), fill(T(2), n))

    return MOProblem(
        n, m, f_rows;
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = jac_rows,
        convexity = meta[:convexity],
    )
end
