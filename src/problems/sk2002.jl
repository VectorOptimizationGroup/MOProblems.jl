"""
Socha, K., & Kisiel-Dorohinicki, M. (2002).
Agent-based evolutionary multiobjective optimisation.
Proceedings of the CEC 2002 (Vol. 1, pp. 109-114). IEEE. https://doi.org/10.1109/CEC.2002.1006218
"""

# ------------------------- SK1 -------------------------
"""
    SK1()

Problem characteristics summary:
- 1 variable
- 2 objectives
- Objectives:
    f₁(x) = x₁⁴ + 3x₁³ - 10x₁² - 10x₁ - 10
    f₂(x) = 0.5x₁⁴ - 2x₁³ - 10x₁² + 10x₁ - 5
- Bounds: [-100, 100] for the variable
"""
function SK1()
    meta = META["SK1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^4 + T(3) * x[1]^3 - T(10) * x[1]^2 - T(10) * x[1] - T(10)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(0.5) * x[1]^4 - T(2) * x[1]^3 - T(10) * x[1]^2 + T(10) * x[1] - T(5)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(4) * x[1]^3 + T(9) * x[1]^2 - T(20) * x[1] - T(10)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]^3 - T(6) * x[1]^2 - T(20) * x[1] + T(10)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- SK2 -------------------------
"""
    SK2()

Problem characteristics summary:
- 4 variables
- 2 objectives
- Objectives:
    f₁(x) = (x₁ - 2)² + (x₂ + 3)² + (x₃ - 5)² + (x₄ - 4)² - 5
    f₂(x) = -[sin(x₁) + sin(x₂) + sin(x₃) + sin(x₄)] / (1 + (x₁² + x₂² + x₃² + x₄²) / 100)
- Bounds: [-10, 10] for all variables
"""
function SK2()
    meta = META["SK2"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(2))^2 + (x[2] + T(3))^2 + (x[3] - T(5))^2 + (x[4] - T(4))^2 - T(5)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        numer = sin(x[1]) + sin(x[2]) + sin(x[3]) + sin(x[4])
        denom = one(T) + (x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2) / T(100)
        return -numer / denom
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(2))
        grad[2] = T(2) * (x[2] + T(3))
        grad[3] = T(2) * (x[3] - T(5))
        grad[4] = T(2) * (x[4] - T(4))
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        denom = one(T) + (x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2) / T(100)
        numer = sin(x[1]) + sin(x[2]) + sin(x[3]) + sin(x[4])
        common = numer / T(50)
        denom2 = denom^2
        grad[1] = (-cos(x[1]) * denom + common * x[1]) / denom2
        grad[2] = (-cos(x[2]) * denom + common * x[2]) / denom2
        grad[3] = (-cos(x[3]) * denom + common * x[3]) / denom2
        grad[4] = (-cos(x[4]) * denom + common * x[4]) / denom2
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-10.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end