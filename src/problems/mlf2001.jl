"""
M. Molyneaux, D. Favrat, and G. B. Leyland, "A New Clustering Evolutionary Multi-Objective Optimisation Technique," Third International Symposium on Adaptative Systems, Institute of Cybernetics, Mathematics and Physics, 2001, pp. 41-47. URL: https://infoscience.epfl.ch/handle/20.500.14299/215484
"""

# ------------------------- MLF1 -------------------------
"""
    MLF1()

Problem characteristics summary:
- 1 variable
- 2 objectives
- Objectives:
    f₁(x) = (1 + x₁/20)sin(x₁)
    f₂(x) = (1 + x₁/20)cos(x₁)
- Bounds: [0, 20] for the variable
"""
function MLF1()
    meta = META["MLF1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) + x[1] / T(20)) * sin(x[1])
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (one(T) + x[1] / T(20)) * cos(x[1])
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = sin(x[1]) / T(20) + (one(T) + x[1] / T(20)) * cos(x[1])
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = cos(x[1]) / T(20) - (one(T) + x[1] / T(20)) * sin(x[1])
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (zeros(n), fill(20.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MLF2 -------------------------
"""
    MLF2()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = -5 + ((x₁² + x₂ - 11)² + (x₁ + x₂² - 7)²) / 200
    f₂(x) = -5 + ((4x₁² + 2x₂ - 11)² + (2x₁ + 4x₂² - 7)²) / 200
- Bounds: [-100, 100] for each variable
"""
function MLF2()
    meta = META["MLF2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = x[1]^2 + x[2] - T(11)
        t2 = x[1] + x[2]^2 - T(7)
        return -T(5) + (t1^2 + t2^2) / T(200)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = T(4) * x[1]^2 + T(2) * x[2] - T(11)
        t2 = T(2) * x[1] + T(4) * x[2]^2 - T(7)
        return -T(5) + (t1^2 + t2^2) / T(200)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = x[1]^2 + x[2] - T(11)
        t2 = x[1] + x[2]^2 - T(7)
        grad[1] = (T(2) * x[1] * t1 + t2) / T(100)
        grad[2] = (t1 + T(2) * x[2] * t2) / T(100)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        t1 = T(4) * x[1]^2 + T(2) * x[2] - T(11)
        t2 = T(2) * x[1] + T(4) * x[2]^2 - T(7)
        grad[1] = (T(8) * x[1] * t1 + T(2) * t2) / T(100)
        grad[2] = (T(2) * t1 + T(8) * x[2] * t2) / T(100)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-100.0, n), fill(100.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end