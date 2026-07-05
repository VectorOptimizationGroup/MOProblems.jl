"""
A. Farhang-Mehr and S. Azarm, "Diversity assessment of Pareto optimal solution sets: an entropy approach," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 723-728 vol.1, DOI: 10.1109/CEC.2002.1007015.
"""

# ------------------------- FA1 -------------------------
"""
    FA1()

Problem characteristics summary:
- 3 variables
- 3 objectives
- Objectives:
    f₁(x) = (1 - exp(-4x₁)) / (1 - exp(-4))
    f₂(x) = (x₂ + 1) * (1 - ((1 - exp(-4x₁)) / (x₂ + 1))^0.5)
    f₃(x) = (x₃ + 1) * (1 - ((1 - exp(-4x₁)) / (x₃ + 1))^0.1)
- Bounds: [1e-2, 1.0] for all variables
"""
function FA1()
    meta = META["FA1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) - exp(-T(4) * x[1])) / (one(T) - exp(-T(4)))
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        num = one(T) - exp(-T(4) * x[1])
        den = x[2] + one(T)
        return den * (one(T) - (num / den)^T(0.5))
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        num = one(T) - exp(-T(4) * x[1])
        den = x[3] + one(T)
        return den * (one(T) - (num / den)^T(0.1))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(4) * exp(-T(4) * x[1]) / (one(T) - exp(-T(4)))
        grad[2] = zero(T)
        grad[3] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = exp(-T(4) * x[1])
        s = (one(T) - a) / (x[2] + one(T))
        grad[1] = -T(2) * a * s^(-T(0.5))
        grad[2] = one(T) - T(0.5) * s^T(0.5)
        grad[3] = zero(T)
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = exp(-T(4) * x[1])
        s = (one(T) - a) / (x[3] + one(T))
        grad[1] = -T(0.4) * a * s^(-T(0.9))
        grad[2] = zero(T)
        grad[3] = one(T) - T(0.9) * s^T(0.1)
        return grad
    end

    bounds = (fill(1e-2, n), fill(1.0, n))

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = bounds,
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end