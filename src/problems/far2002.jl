"""
M. Farina, "A neural network based generalized response surface multiobjective evolutionary algorithm," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 956-961 vol.1, DOI: 10.1109/CEC.2002.1007054.
"""

# ------------------------- Far1 -------------------------
"""
    Far1()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) =  −2·e^{15[−(x₁−0.1)² − x₂²]}
             − e^{20[−(x₁−0.6)² − (x₂−0.6)²]}
             + e^{20[−(x₁+0.6)² − (x₂−0.6)²]}
             + e^{20[−(x₁−0.6)² − (x₂+0.6)²]}
             + e^{20[−(x₁+0.6)² − (x₂+0.6)²]}
    f₂(x) =   2·e^{20[−x₁² − x₂²]}
             + e^{20[−(x₁−0.4)² − (x₂−0.6)²]}
             − e^{20[−(x₁+0.5)² − (x₂−0.7)²]}
             − e^{20[−(x₁−0.5)² − (x₂+0.7)²]}
             + e^{20[−(x₁+0.4)² − (x₂+0.8)²]}
- Bounds: [−1, 1] for each variable
- Convexity: non-convex for both objectives
"""
function Far1()
    meta = META["Far1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        term1 = -T(2) * exp(T(15) * (-((x[1] - T(0.1))^2 + x[2]^2)))
        term2 = -exp(T(20) * (-((x[1] - T(0.6))^2 + (x[2] - T(0.6))^2)))
        term3 = exp(T(20) * (-((x[1] + T(0.6))^2 + (x[2] - T(0.6))^2)))
        term4 = exp(T(20) * (-((x[1] - T(0.6))^2 + (x[2] + T(0.6))^2)))
        term5 = exp(T(20) * (-((x[1] + T(0.6))^2 + (x[2] + T(0.6))^2)))
        return term1 + term2 + term3 + term4 + term5
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        term1 = T(2) * exp(T(20) * (-(x[1]^2 + x[2]^2)))
        term2 = exp(T(20) * (-((x[1] - T(0.4))^2 + (x[2] - T(0.6))^2)))
        term3 = -exp(T(20) * (-((x[1] + T(0.5))^2 + (x[2] - T(0.7))^2)))
        term4 = -exp(T(20) * (-((x[1] - T(0.5))^2 + (x[2] + T(0.7))^2)))
        term5 = exp(T(20) * (-((x[1] + T(0.4))^2 + (x[2] + T(0.8))^2)))
        return term1 + term2 + term3 + term4 + term5
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        e1 = exp(T(15) * (-((x[1] - T(0.1))^2 + x[2]^2)))
        e2 = exp(T(20) * (-((x[1] - T(0.6))^2 + (x[2] - T(0.6))^2)))
        e3 = exp(T(20) * (-((x[1] + T(0.6))^2 + (x[2] - T(0.6))^2)))
        e4 = exp(T(20) * (-((x[1] - T(0.6))^2 + (x[2] + T(0.6))^2)))
        e5 = exp(T(20) * (-((x[1] + T(0.6))^2 + (x[2] + T(0.6))^2)))

        grad[1] = T(60) * (x[1] - T(0.1)) * e1 +
                  T(40) * (x[1] - T(0.6)) * e2 -
                  T(40) * (x[1] + T(0.6)) * e3 -
                  T(40) * (x[1] - T(0.6)) * e4 -
                  T(40) * (x[1] + T(0.6)) * e5

        grad[2] = T(60) * x[2] * e1 +
                  T(40) * (x[2] - T(0.6)) * e2 -
                  T(40) * (x[2] - T(0.6)) * e3 -
                  T(40) * (x[2] + T(0.6)) * e4 -
                  T(40) * (x[2] + T(0.6)) * e5
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        e1 = exp(T(20) * (-(x[1]^2 + x[2]^2)))
        e2 = exp(T(20) * (-((x[1] - T(0.4))^2 + (x[2] - T(0.6))^2)))
        e3 = exp(T(20) * (-((x[1] + T(0.5))^2 + (x[2] - T(0.7))^2)))
        e4 = exp(T(20) * (-((x[1] - T(0.5))^2 + (x[2] + T(0.7))^2)))
        e5 = exp(T(20) * (-((x[1] + T(0.4))^2 + (x[2] + T(0.8))^2)))

        grad[1] = -T(80) * x[1] * e1 -
                  T(40) * (x[1] - T(0.4)) * e2 +
                  T(40) * (x[1] + T(0.5)) * e3 +
                  T(40) * (x[1] - T(0.5)) * e4 -
                  T(40) * (x[1] + T(0.4)) * e5

        grad[2] = -T(80) * x[2] * e1 -
                  T(40) * (x[2] - T(0.6)) * e2 +
                  T(40) * (x[2] - T(0.7)) * e3 +
                  T(40) * (x[2] + T(0.7)) * e4 -
                  T(40) * (x[2] + T(0.8)) * e5
        return grad
    end

    bounds = (fill(-1.0, n), fill(1.0, n))

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = bounds,
        jacobian = (df1_dx, df2_dx),
    )
end