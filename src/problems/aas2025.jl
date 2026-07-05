"""
    Examples 1 from the paper: Amaral, V.S. & Assunção, P.B. & Souza, D.R. (2025): A Derivative-Free Proximal Method with Quadratic Modeling for Composite Multiobjective Optimization in the H¨older Setting
"""

# ------------------------- AAS1 -------------------------
"""
    AAS1()

A function with a Lipschitz continuous gradient and a Hölder continuous gradient.

The domain is the square [-2, 2] x [-2, 2].

f₁(x) = (1/2) * ||A₁x - b₁||₂²
f₂(x) = (λ/p) * ||Φ₂x||ₚᵖ
"""
function AAS1()
    meta = META["AAS1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        r1 = T(2.0) * x[1] + T(0.5) * x[2] - one(T)
        r2 = T(0.5) * x[1] + T(1.5) * x[2] + T(0.5)
        return T(0.5) * (r1 * r1 + r2 * r2)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        p = T(1.003)
        λ = T(0.9)
        y1 = x[1] + T(0.8) * x[2]
        y2 = T(0.3) * x[1] + T(1.2) * x[2]
        return (λ / p) * (abs(y1)^p + abs(y2)^p)
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds=(fill(-2.0, n), fill(2.0, n)), #TODO: Is this really necessary? Why does this problem have bounds?
    )
end

# ------------------------- AAS2 -------------------------
"""
    AAS2()

A function with two Hölder continuous gradient functions.

Características:
- Número de variáveis: 2 (fixo)
- Número de objetivos: 2
- Domínio: [-5, 5]²

Fórmulas:
- f₁(x) = (λ₁/p₁) * ||Φ₁(x - c₁)||ₚ₁ᵖ¹
- f₂(x) = (λ₂/p₂) * ||Φ₂(x - c₂)||ₚ₂ᵖ²
"""
function AAS2()
    meta = META["AAS2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        p = T(1.003)
        λ = T(1.2)
        u1 = x[1] - T(1.5)
        u2 = x[2] + one(T)
        y1 = T(1.2) * u1 - T(0.3) * u2
        y2 = T(0.4) * u1 + T(1.5) * u2
        return (λ / p) * (abs(y1)^p + abs(y2)^p)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        p = T(1.002)
        λ = T(0.8)
        u1 = x[1] + T(1.2)
        u2 = x[2] - T(0.8)
        y1 = T(1.8) * u1 + T(0.5) * u2
        y2 = -T(0.2) * u1 + T(1.1) * u2
        return (λ / p) * (abs(y1)^p + abs(y2)^p)
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds=(fill(-5.0, n), fill(5.0, n)), # The minimum of each function can be found within the box
    )
end
