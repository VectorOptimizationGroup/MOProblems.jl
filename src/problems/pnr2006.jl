"""
Preuss, M., Naujoks, B., Rudolph, G. (2006). Pareto Set and EMOA Behavior for Simple Multimodal
Multiobjective Functions. In: Runarsson, T.P., Beyer, H.-G., Burke, E., Merelo-Guervós, J.J.,
Whitley, L.D., Yao, X. (eds) Parallel Problem Solving from Nature - PPSN IX. Lecture Notes in
Computer Science, vol 4193. Springer, Berlin, Heidelberg. https://doi.org/10.1007/11844297_52
"""

# ------------------------- PNR -------------------------
"""
    PNR()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁⁴ + x₂⁴ - x₁² + x₂² - 10x₁x₂ + 20
    f₂(x) = x₁² + x₂²
- Bounds: [-2, 2] for each variable
- Convexity: [non-convex, strictly convex]
"""
function PNR()
    meta = META["PNR"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^4 + x[2]^4 - x[1]^2 + x[2]^2 - T(10) * x[1] * x[2] + T(20)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + x[2]^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(4) * x[1]^3 - T(2) * x[1] - T(10) * x[2]
        grad[2] = T(4) * x[2]^3 + T(2) * x[2] - T(10) * x[1]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = T(2) * x[2]
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-2.0, n), fill(2.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end