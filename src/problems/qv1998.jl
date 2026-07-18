"""
D. Quagliarella and A. Vicini, "Sub-population policies for a parallel multiobjective genetic algorithm with
applications to wing design," SMC'98 Conference Proceedings. 1998 IEEE International Conference on Systems,
Man, and Cybernetics, San Diego, CA, USA, 1998, pp. 3142-3147, doi: 10.1109/ICSMC.1998.726485.
"""

# ------------------------- QV1 -------------------------
"""
    QV1(n::Int = 16)

Problem characteristics summary:
- `n` variables
- 2 objectives
- Objectives:
    f₁(x) = ((1/n)∑ᵢ[xᵢ² - 10cos(2πxᵢ) + 10])^(1/4)
    f₂(x) = ((1/n)∑ᵢ[(xᵢ - 1.5)² - 10cos(2π(xᵢ - 1.5)) + 10])^(1/4)
- Bounds: [-5.12, 5.12] for all variables
"""
function QV1(n::Int = 16)
    n >= 1 || throw(ArgumentError("n must be at least 1 for QV1"))
    meta = META["QV1"]
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            s += x[i]^2 - T(10) * cos(twoπ * x[i]) + T(10)
        end
        return (s / T(n))^T(0.25)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            s += y^2 - T(10) * cos(twoπ * y) + T(10)
        end
        return (s / T(n))^T(0.25)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            s += x[i]^2 - T(10) * cos(twoπ * x[i]) + T(10)
        end

        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        @inbounds for i in 1:n
            grad[i] = factor * (T(2) * x[i] + T(20) * T(π) * sin(twoπ * x[i]))
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            s += y^2 - T(10) * cos(twoπ * y) + T(10)
        end

        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            grad[i] = factor * (T(2) * y + T(20) * T(π) * sin(twoπ * y))
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-5.12, n), fill(5.12, n)),
        jacobian = (df1_dx, df2_dx),
    )
end