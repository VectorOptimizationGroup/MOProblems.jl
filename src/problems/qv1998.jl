"""
D. Quagliarella and A. Vicini, "Sub-population policies for a parallel multiobjective genetic algorithm with
applications to wing design," SMC'98 Conference Proceedings. 1998 IEEE International Conference on Systems,
Man, and Cybernetics, San Diego, CA, USA, 1998, pp. 3142-3147, doi: 10.1109/ICSMC.1998.726485.
"""

# ------------------------- QV1 -------------------------
"""
    QV1(n::Int = 16; T::Type{<:AbstractFloat}=Float64)

Problem characteristics summary:
- 10 variables
- 2 objectives
- Objectives (Rastrigin-like aggregations):
    f₁(x) = ( (1/n) Σ [ xᵢ² − 10 cos(2πxᵢ) + 10 ] )^{1/4}
    f₂(x) = ( (1/n) Σ [ (xᵢ−1.5)² − 10 cos(2π(xᵢ−1.5)) + 10 ] )^{1/4}
- Bounds: [1e−2, 5] for each variable
- Convexity: non-convex for both objectives
"""
function QV1(n::Int = 16; T::Type{<:AbstractFloat}=Float64)
    @assert n >= 1 "QV1 requer pelo menos 1 variável"
    meta = META["QV1"]
    m = meta[:nobj]

    twoπ = T(2) * T(pi)

    # ------------------------------------------------------------------
    # Objective functions
    # ------------------------------------------------------------------
    f1 = function (x)
        s = zero(T)
        for i in 1:n
            xi = x[i]
            s += xi^2 - T(10)*cos(twoπ*xi) + T(10)
        end
        return (s / T(n))^(T(0.25))
    end

    f2 = function (x)
        s = zero(T)
        for i in 1:n
            yi = x[i] - T(1.5)
            s += yi^2 - T(10)*cos(twoπ*yi) + T(10)
        end
        return (s / T(n))^(T(0.25))
    end

    # ------------------------------------------------------------------
    # Analytical gradients (rows of the Jacobian)
    # ------------------------------------------------------------------
    df1_dx = function (x)
        s = zero(T)
        for i in 1:n
            xi = x[i]
            s += xi^2 - T(10)*cos(twoπ*xi) + T(10)
        end
        # common scalar factor: 0.25 * (s/n)^(-0.75) / n
        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        g = Vector{T}(undef, n)
        for i in 1:n
            xi = x[i]
            g[i] = factor * (T(2)*xi + T(20)*T(pi)*sin(twoπ*xi))
        end
        return g
    end

    df2_dx = function (x)
        s = zero(T)
        for i in 1:n
            yi = x[i] - T(1.5)
            s += yi^2 - T(10)*cos(twoπ*yi) + T(10)
        end
        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        g = Vector{T}(undef, n)
        for i in 1:n
            yi = x[i] - T(1.5)
            g[i] = factor * (T(2)*yi + T(20)*T(pi)*sin(twoπ*yi))
        end
        return g
    end

    # Complete Jacobian (m × n)
    jacobian = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1_dx(x)
        J[2, :] = df2_dx(x)
        return J
    end

    bounds = (fill(T(-5.12), n), fill(T(5.12), n))

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
