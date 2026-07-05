"""    
    Lovison, Alberto. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis.
    SIAM Journal on Optimization, 21(2), 463-490. DOI: 10.1137/100784746
"""

# ------------------------- Lov1 -------------------------
"""    
    Lov1()

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = -(-1.05 * x₁² - 0.98 * x₂²)
  - f₂(x) = -(-0.99 * (x₁ - 3)² - 1.03 * (x₂ - 2.5)²)
- Limites: [-10, 10] para todas as variáveis
- Convexidade: [estritamente convexa, estritamente convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov1()
    meta = META["Lov1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(1.05) * x[1]^2 + T(0.98) * x[2]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(0.99) * (x[1] - T(3))^2 + T(1.03) * (x[2] - T(2.5))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2.1) * x[1]
        grad[2] = T(1.96) * x[2]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(1.98) * (x[1] - T(3))
        grad[2] = T(2.06) * (x[2] - T(2.5))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-10.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Lov3 -------------------------
"""
    Lov3()

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² + x₂²
  - f₂(x) = (x₁ - 6)² - (x₂ + 0.3)²
- Limites: [-1, 1] para todas as variáveis
- Convexidade: [estritamente convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov3()
    meta = META["Lov3"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + x[2]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(6))^2 - (x[2] + T(0.3))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = T(2) * x[2]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(6))
        grad[2] = -T(2) * (x[2] + T(0.3))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Lov4 -------------------------
"""
    Lov4()

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = -(-x₁² - x₂² - 4(exp(-(x₁+2)² - x₂²) + exp(-(x₁-2)² - x₂²)))
  - f₂(x) = -(-(x₁ - 6)² - (x₂ + 0.5)²)
- Limites: [-20, 20] para todas as variáveis
- Convexidade: [não convexa, estritamente convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov4()
    meta = META["Lov4"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        exp1 = exp(-(x[1] + T(2))^2 - x[2]^2)
        exp2 = exp(-(x[1] - T(2))^2 - x[2]^2)
        return x[1]^2 + x[2]^2 + T(4) * (exp1 + exp2)
    end
    
    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(6))^2 + (x[2] + T(0.5))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp1 = exp(-(x[1] + T(2))^2 - x[2]^2)
        exp2 = exp(-(x[1] - T(2))^2 - x[2]^2)
        
        grad[1] = T(2) * x[1] - T(8) * ((x[1] + T(2)) * exp1 + (x[1] - T(2)) * exp2)
        grad[2] = T(2) * x[2] - T(8) * (x[2] * exp1 + x[2] * exp2)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(6))
        grad[2] = T(2) * (x[2] + T(0.5))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-20.0, n), fill(20.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Lov5 -------------------------
"""
    Lov5()

Características
- 3 variáveis
- 2 funções objetivo
- Definido a partir de:
  - p₀ = (0.0, 0.15, 0.0)
  - p₁ = (0.0, -1.1, 0.0)
  - M = [-1.0 -0.03 0.011; -0.03 -1.0 0.07; 0.011 0.07 -1.01]
- Função auxiliar:
  - g(x, y, z, M, p, σ) = √(2π / σ) exp((((x, y, z) - p)'M((x, y, z) - p)) / σ²)
  - f(x, y, z) = g(x, y, z, M, p₀, 0.35) + g(x, y, 0.5z, M, p₁, 3.0)
- Formulação original de maximização:
  - u₁(x, y, z) = √2/2 * x + √2/2 * f(x, y, z)
  - u₂(x, y, z) = -√2/2 * x + √2/2 * f(x, y, z)
- Objetivos implementados para minimização:
  - f₁(x, y, z) = -u₁(x, y, z)
  - f₂(x, y, z) = -u₂(x, y, z)
- Limites: [-2, 2] para todas as variáveis
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov5()
    meta = META["Lov5"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    g = function (x::T, y::T, z::T, px::T, py::T, pz::T, σ::T) where {T <: AbstractFloat}
        m11 = -one(T)
        m12 = T(-0.03)
        m13 = T(0.011)
        m22 = -one(T)
        m23 = T(0.07)
        m33 = T(-1.01)

        vx = x - px
        vy = y - py
        vz = z - pz
        q = m11 * vx^2 + T(2) * m12 * vx * vy + T(2) * m13 * vx * vz +
            m22 * vy^2 + T(2) * m23 * vy * vz + m33 * vz^2

        return sqrt(T(2) * T(π) / σ) * exp(q / σ^2)
    end

    f = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return g(x[1], x[2], x[3], zero(T), T(0.15), zero(T), T(0.35)) +
               g(x[1], x[2], T(0.5) * x[3], zero(T), T(-1.1), zero(T), T(3))
    end

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return -sqrt(T(2)) / T(2) * (x[1] + f(x))
    end
    
    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return -sqrt(T(2)) / T(2) * (-x[1] + f(x))
    end

    df_dx = function (df::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        m11 = -one(T)
        m12 = T(-0.03)
        m13 = T(0.011)
        m22 = -one(T)
        m23 = T(0.07)
        m33 = T(-1.01)
        σ0 = T(0.35)
        σ1 = T(3)

        v0x = x[1]
        v0y = x[2] - T(0.15)
        v0z = x[3]
        g0 = g(x[1], x[2], x[3], zero(T), T(0.15), zero(T), σ0)
        dg0_dx = g0 * T(2) * (m11 * v0x + m12 * v0y + m13 * v0z) / σ0^2
        dg0_dy = g0 * T(2) * (m12 * v0x + m22 * v0y + m23 * v0z) / σ0^2
        dg0_dz = g0 * T(2) * (m13 * v0x + m23 * v0y + m33 * v0z) / σ0^2

        v1x = x[1]
        v1y = x[2] + T(1.1)
        v1z = T(0.5) * x[3]
        g1 = g(x[1], x[2], T(0.5) * x[3], zero(T), T(-1.1), zero(T), σ1)
        dg1_dx = g1 * T(2) * (m11 * v1x + m12 * v1y + m13 * v1z) / σ1^2
        dg1_dy = g1 * T(2) * (m12 * v1x + m22 * v1y + m23 * v1z) / σ1^2
        dg1_dz = g1 * (m13 * v1x + m23 * v1y + m33 * v1z) / σ1^2

        df[1] = dg0_dx + dg1_dx
        df[2] = dg0_dy + dg1_dy
        df[3] = dg0_dz + dg1_dz
        return df
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        df_dx(grad, x)
        scale = sqrt(T(2)) / T(2)
        grad[1] = -scale * (one(T) + grad[1])
        grad[2] *= -scale
        grad[3] *= -scale
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        df_dx(grad, x)
        scale = sqrt(T(2)) / T(2)
        grad[1] = -scale * (-one(T) + grad[1])
        grad[2] *= -scale
        grad[3] *= -scale
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-2.0, n), fill(2.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Lov6 -------------------------
"""
    Lov6()

Características
- 6 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁
  - f₂(x) = 1 - √x₁ - x₁sin(10πx₁) + x₂² + x₃² + x₄² + x₅² + x₆²
- Limites: x₁ ∈ [0.1, 0.425], x₂₋₆ ∈ [-0.16, 0.16]
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov6()
    meta = META["Lov6"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end
    
    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return one(T) - sqrt(x[1]) - x[1] * sin(T(10) * π * x[1]) +
               x[2]^2 + x[3]^2 + x[4]^2 + x[5]^2 + x[6]^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(grad, zero(T))
        grad[1] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -T(0.5) / sqrt(x[1]) - sin(T(10) * π * x[1]) - T(10) * π * x[1] * cos(T(10) * π * x[1])
        for i in 2:6
            grad[i] = T(2) * x[i]
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = ([0.1, -0.16, -0.16, -0.16, -0.16, -0.16], [0.425, 0.16, 0.16, 0.16, 0.16, 0.16]),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Lov2 -------------------------
"""    
    Lov2()

Características
- 2 variáveis
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₂
  - f₂(x) = -((x₂ - x₁³) / (x₁ + 1))
- Limites: [-0.75, 0.75] para todas as variáveis
- Convexidade: [não convexa, não convexa]

Referência:
- Lovison, A. (2011). Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis. SIAM Journal on Optimization, 21(2), 463-490.
"""
function Lov2()
    meta = META["Lov2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[2]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return -((x[2] - x[1]^3) / (x[1] + one(T)))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = zero(T)
        grad[2] = one(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -((-T(3) * x[1]^2 * (x[1] + one(T)) - (x[2] - x[1]^3)) / (x[1] + one(T))^2)
        grad[2] = -one(T) / (x[1] + one(T))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-0.75, n), fill(0.75, n)),
        jacobian = (df1_dx, df2_dx),
    )
end