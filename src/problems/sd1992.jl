"""
Stadler, W., Dauer, J. Multicriteria Optimization in Engineering: A Tutorial and Survey.
In: Kamat, M.P. (ed.) Structural Optimization: Status and Promise, Progress in Aeronautics and Astronautics,
vol. 150, pp. 209-249. AIAA, Reston (1992). doi:10.2514/5.9781600866234.0209.0249
"""

# ------------------------- SD -------------------------
"""
    SD()

Problem characteristics summary:
- 4 variables
- 2 objectives
- Objectives:
    f₁(x) = 2x₁ + √2(x₂ + x₃) + x₄
    f₂(x) = 2/x₁ + 2√2/x₂ + 2√2/x₃ + 2/x₄
- Bounds: x₁ in [1, 3], x₂ in [√2, 3], x₃ in [√2, 3], x₄ in [1, 3]
"""
function SD()
    meta = META["SD"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(2) * x[1] + sqrt(T(2)) * (x[2] + x[3]) + x[4]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sqrt2 = sqrt(T(2))
        return T(2) / x[1] + T(2) * sqrt2 / x[2] + T(2) * sqrt2 / x[3] + T(2) / x[4]
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2)
        grad[2] = sqrt(T(2))
        grad[3] = sqrt(T(2))
        grad[4] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        sqrt2 = sqrt(T(2))
        grad[1] = -T(2) / x[1]^2
        grad[2] = -T(2) * sqrt2 / x[2]^2
        grad[3] = -T(2) * sqrt2 / x[3]^2
        grad[4] = -T(2) / x[4]^2
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = ([1.0, sqrt(2.0), sqrt(2.0), 1.0], [3.0, 3.0, 3.0, 3.0]),
        jacobian = (df1_dx, df2_dx),
    )
end