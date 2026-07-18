"""
Shim, M.-B., Suh, M.-W., Furukawa, T., Yagawa, G., Yoshimura, S. (2002).
Pareto-based continuous evolutionary algorithms for multiobjective optimization.
Engineering Computations, 19(1), 22-48. https://doi.org/10.1108/02644400210413649
"""

# ------------------------- SSFYY2 -------------------------
"""
    SSFYY2()

Problem characteristics summary:
- 1 variable
- 2 objectives
- Objectives:
    f₁(x) = 10 + x₁² - 10cos(πx₁ / 2)
    f₂(x) = (x₁ - 4)²
- Bounds: [-100, 100] for the variable
"""
function SSFYY2()
    meta = META["SSFYY2"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(10) + x[1]^2 - T(10) * cos(T(π) * x[1] / T(2))
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(4))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1] + T(5) * T(π) * sin(T(π) * x[1] / T(2))
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(4))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end