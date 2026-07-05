"""
    Examples 1, 2, 3 and 4 from:

    Ansary, Md. A. T., & Panda, G. (2014). A modified Quasi-Newton method for vector optimization problem. Optimization, 64(11), 2289–2306. DOI: 10.1080/02331934.2014.947500
"""

# ------------------------- AP1 -------------------------
"""
    AP1()

Características
- 2 variáveis
- 3 funções objetivo
- Objetivos:
  - f₁(x) = 0.25 * ((x₁ - 1)^4 + 2(x₂ - 2)^4)
  - f₂(x) = exp((x₁ + x₂)/2) + x₁² + x₂²
  - f₃(x) = (1/6) * (exp(-x₁) + 2exp(-x₂))
- Limites: [-10, 10] para todas as variáveis
"""
function AP1()
    meta = META["AP1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(0.25) * ((x[1] - one(T))^4 + T(2.0) * (x[2] - T(2.0))^4)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return exp((x[1] + x[2]) / T(2.0)) + x[1]^2 + x[2]^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) / T(6.0)) * (exp(-x[1]) + T(2.0) * exp(-x[2]))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = (x[1] - one(T))^3
        grad[2] = T(2.0) * (x[2] - T(2.0))^3
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp_term = exp((x[1] + x[2]) / T(2.0))
        grad[1] = T(0.5) * exp_term + T(2.0) * x[1]
        grad[2] = T(0.5) * exp_term + T(2.0) * x[2]
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -(one(T) / T(6.0)) * exp(-x[1])
        grad[2] = -(one(T) / T(3.0)) * exp(-x[2])
        return grad
    end

    h1 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = T(3.0) * (x[1] - one(T))^2
        H[2, 2] = T(6.0) * (x[2] - T(2.0))^2
        return H
    end

    h2 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp_term = exp((x[1] + x[2]) / T(2.0))
        c = T(0.25) * exp_term
        H[1, 1] = c + T(2.0)
        H[2, 2] = c + T(2.0)
        H[1, 2] = c
        H[2, 1] = c
        return H
    end

    h3 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = one(T) / T(6.0) * exp(-x[1])
        H[2, 2] = one(T) / T(3.0) * exp(-x[2])
        return H
    end

    return MOProblem(
        n,
        m,
        (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-10.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
        hessian = (h1, h2, h3),
    )
end

# ------------------------- AP2 -------------------------
"""
    AP2()

Características
- 1 variável
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁² - 4
  - f₂(x) = (x₁ - 1)²
- Limites: [-100, 100]
"""
function AP2()
    meta = META["AP2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 - T(4.0)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - one(T))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2.0) * x[1]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2.0) * (x[1] - one(T))
        return grad
    end

    h1 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = T(2.0)
        return H
    end

    h2 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = T(2.0)
        return H
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
        hessian = (h1, h2),
    )
end

# ------------------------- AP3 -------------------------
"""
    AP3()
"""
function AP3()
    meta = META["AP3"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(0.25) * ((x[1] - one(T))^4 + T(2.0) * (x[2] - T(2.0))^4)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[2] - x[1]^2)^2 + (one(T) - x[1])^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = (x[1] - one(T))^3
        grad[2] = T(2.0) * (x[2] - T(2.0))^3
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -T(4.0) * x[1] * (x[2] - x[1]^2) - T(2.0) * (one(T) - x[1])
        grad[2] = T(2.0) * (x[2] - x[1]^2)
        return grad
    end

    h1 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = T(3.0) * (x[1] - one(T))^2
        H[2, 2] = T(6.0) * (x[2] - T(2.0))^2
        return H
    end

    h2 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = -T(4.0) * (x[2] - x[1]^2) + T(8.0) * x[1]^2 + T(2.0)
        H[1, 2] = -T(4.0) * x[1]
        H[2, 1] = H[1, 2]
        H[2, 2] = T(2.0)
        return H
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
        hessian = (h1, h2),
    )
end

# ------------------------- AP4 -------------------------
"""
    AP4()
"""
function AP4()
    meta = META["AP4"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) / T(9.0)) * (
            (x[1] - one(T))^4 +
            T(2.0) * (x[2] - T(2.0))^4 +
            T(3.0) * (x[3] - T(3.0))^4
        )
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return exp((x[1] + x[2] + x[3]) / T(3.0)) + x[1]^2 + x[2]^2 + x[3]^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) / T(12.0)) * (T(3.0) * exp(-x[1]) + T(4.0) * exp(-x[2]) + T(3.0) * exp(-x[3]))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = (T(4.0) / T(9.0)) * (x[1] - one(T))^3
        grad[2] = (T(8.0) / T(9.0)) * (x[2] - T(2.0))^3
        grad[3] = (T(12.0) / T(9.0)) * (x[3] - T(3.0))^3
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        exp_term = exp((x[1] + x[2] + x[3]) / T(3.0))
        grad[1] = (one(T) / T(3.0)) * exp_term + T(2.0) * x[1]
        grad[2] = (one(T) / T(3.0)) * exp_term + T(2.0) * x[2]
        grad[3] = (one(T) / T(3.0)) * exp_term + T(2.0) * x[3]
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = -(one(T) / T(4.0)) * exp(-x[1])
        grad[2] = -(one(T) / T(3.0)) * exp(-x[2])
        grad[3] = -(one(T) / T(4.0)) * exp(-x[3])
        return grad
    end

    h1 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = (T(12.0) / T(9.0)) * (x[1] - one(T))^2
        H[2, 2] = (T(24.0) / T(9.0)) * (x[2] - T(2.0))^2
        H[3, 3] = (T(36.0) / T(9.0)) * (x[3] - T(3.0))^2
        return H
    end

    h2 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t = (one(T) / T(9.0)) * exp((x[1] + x[2] + x[3]) / T(3.0))
        for i in 1:n, j in 1:n
            H[i, j] = t
        end
        for i in 1:n
            H[i, i] += T(2.0)
        end
        return H
    end

    h3 = function (H::AbstractMatrix{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        fill!(H, zero(T))
        H[1, 1] = (one(T) / T(4.0)) * exp(-x[1])
        H[2, 2] = (one(T) / T(3.0)) * exp(-x[2])
        H[3, 3] = (one(T) / T(4.0)) * exp(-x[3])
        return H
    end

    return MOProblem(
        n,
        m,
        (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-10.0, n), fill(10.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
        hessian = (h1, h2, h3),
    )
end