"""
C. Hillermeier, "Generalized Homotopy Approach to Multiobjective Optimization," Journal of Optimization Theory and Applications, vol. 110, pp. 557–583, 2001. DOI: 10.1023/A:1017536311488.
"""

# ------------------------- HIL1 -------------------------
"""
    Hil1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = cos(a) * b
    f₂(x) = sin(a) * b
    where:
    a = (2π/360) * (45 + 40*sin(2π*x₁) + 25*sin(2π*x₂))
    b = 1 + 0.5*cos(2π*x₁)
- Bounds: [0, 1] for each variable
"""
function Hil1()
    meta = META["Hil1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = T(2) * T(π) / T(360) * (T(45) + T(40) * sin(T(2) * T(π) * x[1]) + T(25) * sin(T(2) * T(π) * x[2]))
        b = one(T) + T(0.5) * cos(T(2) * T(π) * x[1])
        return cos(a) * b
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = T(2) * T(π) / T(360) * (T(45) + T(40) * sin(T(2) * T(π) * x[1]) + T(25) * sin(T(2) * T(π) * x[2]))
        b = one(T) + T(0.5) * cos(T(2) * T(π) * x[1])
        return sin(a) * b
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = T(2) * T(π) / T(360) * (T(45) + T(40) * sin(T(2) * T(π) * x[1]) + T(25) * sin(T(2) * T(π) * x[2]))
        b = one(T) + T(0.5) * cos(T(2) * T(π) * x[1])

        grad[1] = -T(160) * T(π)^2 / T(360) * cos(T(2) * T(π) * x[1]) * sin(a) * b -
                  T(π) * sin(T(2) * T(π) * x[1]) * cos(a)
        grad[2] = -T(100) * T(π)^2 / T(360) * cos(T(2) * T(π) * x[2]) * sin(a) * b
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = T(2) * T(π) / T(360) * (T(45) + T(40) * sin(T(2) * T(π) * x[1]) + T(25) * sin(T(2) * T(π) * x[2]))
        b = one(T) + T(0.5) * cos(T(2) * T(π) * x[1])

        grad[1] = T(160) * T(π)^2 / T(360) * cos(T(2) * T(π) * x[1]) * cos(a) * b -
                  T(π) * sin(T(2) * T(π) * x[1]) * sin(a)
        grad[2] = T(100) * T(π)^2 / T(360) * cos(T(2) * T(π) * x[2]) * cos(a) * b
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end