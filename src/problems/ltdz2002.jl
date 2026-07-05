"""
    LTDZ()

Problem characteristics summary:
- 3 variables
- 3 objectives
- Objectives:
    f₁(x) = -3 + (1 + x₃)cos(πx₁/2)cos(πx₂/2)
    f₂(x) = -3 + (1 + x₃)cos(πx₁/2)sin(πx₂/2)
    f₃(x) = -3 + (1 + x₃)cos(πx₁/2)sin(πx₁/2)
- Bounds: [0, 1] for all variables

Referência:
M. Laumanns, L. Thiele, K. Deb, E. Zitzler, Combining Convergence and Diversity in Evolutionary
Multiobjective Optimization, Evolutionary Computation, 10(3):263–282, 2002. DOI: 10.1162/106365602760234108
"""
function LTDZ()
    meta = META["LTDZ"]
    n = default_nvar(meta.dimension)  # 3
    m = default_nobj(meta.dimension)  # 3

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        b = x[2] * halfpi
        return T(-3) + (one(T) + x[3]) * cos(a) * cos(b)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        b = x[2] * halfpi
        return T(-3) + (one(T) + x[3]) * cos(a) * sin(b)
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        return T(-3) + (one(T) + x[3]) * cos(a) * sin(a)
    end

    df1_dx = function (g::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        b = x[2] * halfpi
        g[1] = -halfpi * (one(T) + x[3]) * sin(a) * cos(b)
        g[2] = -halfpi * (one(T) + x[3]) * cos(a) * sin(b)
        g[3] =  cos(a) * cos(b)
        return g
    end

    df2_dx = function (g::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        b = x[2] * halfpi
        g[1] = -halfpi * (one(T) + x[3]) * sin(a) * sin(b)
        g[2] =  halfpi * (one(T) + x[3]) * cos(a) * cos(b)
        g[3] =  cos(a) * sin(b)
        return g
    end

    df3_dx = function (g::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        halfpi = T(π) / T(2)
        a = x[1] * halfpi
        cosa = cos(a); sina = sin(a)
        g[1] = halfpi * (one(T) + x[3]) * (cosa * cosa - sina * sina)
        g[2] = zero(T)
        g[3] =  cosa * sina
        return g
    end

    return MOProblem(
        n,
        m,
        (f1, f2, f3);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end