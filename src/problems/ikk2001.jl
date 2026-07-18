"""
K. Ikeda, H. Kita and S. Kobayashi, "Failure of Pareto-based MOEAs: does non-dominated really mean near to optimal?," Proceedings of the 2001 Congress on Evolutionary Computation (IEEE Cat. No.01TH8546), Seoul, Korea (South), 2001, pp. 957-962 vol. 2. DOI: 10.1109/CEC.2001.934293.
"""

# ------------------------- IKK1 -------------------------
"""
    IKK1()

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = x₁²
    f₂(x) = (x₁ - 20)²
    f₃(x) = x₂²
- Bounds: [-50, 50] for each variable
"""
function IKK1()
    meta = META["IKK1"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(20))^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[2]^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(20))
        grad[2] = zero(T)
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = zero(T)
        grad[2] = T(2) * x[2]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-50.0, n), fill(50.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end