"""Jiangming Mao, K. Hirasawa, Jinlu Hu, J. Murata, "Genetic symbiosis algorithm for multiobjective optimization problem," 
Proceedings 9th IEEE International Workshop on Robot and Human Interactive Communication. IEEE RO-MAN 2000 (Cat. No.00TH8499), pp. 137-142, 2000.
DOI: 10.1109/ROMAN.2000.892484
"""
# ------------------------- MHHM1 -------------------------
"""
    MHHM1()

Problem characteristics summary:
- 1 variable
- 3 objectives
- Objectives:
    f₁(x) = (x₁ - 0.8)²
    f₂(x) = (x₁ - 0.85)²
    f₃(x) = (x₁ - 0.9)²
- Bounds: [0, 1] for all variables
"""
function MHHM1()
    meta = META["MHHM1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.8))^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.85))^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.9))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.8))
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.85))
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.9))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end

# ------------------------- MHHM2 -------------------------
"""
    MHHM2()

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = (x₁ - 0.8)² + (x₂ - 0.6)²
    f₂(x) = (x₁ - 0.85)² + (x₂ - 0.7)²
    f₃(x) = (x₁ - 0.9)² + (x₂ - 0.6)²
- Bounds: [0, 1] for all variables
"""
function MHHM2()
    meta = META["MHHM2"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.8))^2 + (x[2] - T(0.6))^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.85))^2 + (x[2] - T(0.7))^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(0.9))^2 + (x[2] - T(0.6))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.8))
        grad[2] = T(2) * (x[2] - T(0.6))
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.85))
        grad[2] = T(2) * (x[2] - T(0.7))
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(0.9))
        grad[2] = T(2) * (x[2] - T(0.6))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end