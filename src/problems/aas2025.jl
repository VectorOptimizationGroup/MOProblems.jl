"""
    Examples 1 from the paper: Amaral, V.S. & Assunção, P.B. & Souza, D.R. (2025): A multiobjective algorithm for composite problems in the smooth holder setting.
    """
    # ------------------------- AAS1 -------------------------
    """
    AAS1()

    A function with a Lipschitz continuous gradient and a Hölder continuous gradient.

    AAS1(; T::Type{<:AbstractFloat}=Float64,
         A1 = [2.0 0.5; 0.5 1.5],
         b1 = [1.0; -0.5],
         p = 1.5,
         λ = 0.9,
         Φ2 = [1.0 0.8; 0.3 1.2])

A function with a Lipschitz continuous gradient and a Hölder continuous gradient.

The domain is the square [-2, 2] x [-2, 2].

f₁(x) = (1/2) * ||A₁x - b₁||₂²
f₂(x) = (λ/p) * ||Φ₂x||ₚᵖ

# Arguments
 - `T`: The float type to use.
 - `A1`: Positive definite matrix for f₁.
 - `b1`: Vector for f₁.
 - `p`: Exponent for f₂ (1 < p < 2).
 - `λ`: Parameter for f₂.
 - `Φ2`: Linear transformation matrix for f₂.
"""
function AAS1(; T::Type{<:AbstractFloat}=Float64,
    A1=[2.0 0.5; 0.5 1.5],
    b1=[1.0; -0.5],
    p=1.003,
    λ=0.9,
    Φ2=[1.0 0.8; 0.3 1.2]
)
    meta = META["AAS1"]
    n = meta[:nvar]
    m = meta[:nobj]

    A1_T = T.(A1)
    b1_T = T.(b1)
    Φ2_T = T.(Φ2)
    p_T = T(p)
    λ_T = T(λ)

    f1 = x -> T(0.5) * norm(A1_T * x - b1_T)^2

    f2 = x -> begin
        Φx = Φ2_T * x
        return (λ_T / p_T) * (abs(Φx[1])^p_T + abs(Φx[2])^p_T)
    end

    grad_f1 = x -> A1_T' * (A1_T * x - b1_T)

    grad_f2 = x -> begin
        Φx = Φ2_T * x
        grad_norm = [sign(Φx[1]) * abs(Φx[1])^(p_T - 1),
                     sign(Φx[2]) * abs(Φx[2])^(p_T - 1)]
        return λ_T * Φ2_T' * grad_norm
    end

    jacobian = x -> [grad_f1(x)'; grad_f2(x)']

    return MOProblem(
        n,
        m,
        [f1, f2];
        name=meta[:name],
        origin=meta[:origin],
        minimize=meta[:minimize],
        has_bounds=meta[:has_bounds],
        bounds=(fill(T(-2.0), n), fill(T(2.0), n)), #TODO: Is this really necessary? Why does this problem have bounds?
        has_jacobian=true,
        jacobian=jacobian,
        jacobian_by_row=[grad_f1, grad_f2],
        convexity=meta[:convexity]
    )
end

# ------------------------- AAS2 -------------------------
"""
    AAS2()

A function with two Hölder continuous gradient functions.

AAS2(; T::Type{<:AbstractFloat}=Float64,
     p1 = 1.003,
     λ1 = 1.2,
     Φ1 = [1.2 -0.3; 0.4 1.5],
     c1 = [1.5; -1.0]
     p2 = 1.003,
     λ2 = 0.8,
     Φ2 = [1.8 0.5; -0.2 1.1]
     c2 = [-1.2; 0.8])

A function with two Hölder continuous gradient functions.

The domain is the square [-2, 2] x [-2, 2].

f₁(x) = (λ₁/p₁) * ||Φ₁x||ₚ₁ᵖ¹
f₂(x) = (λ₂/p₂) * ||Φ₂x||ₚ₂ᵖ²

# Arguments
 - `T`: The float type to use.
 - `p1`: Exponent for f₁ (1 < p < 2).
 - `λ1`: Parameter for f₁.
 - `Φ1`: Linear transformation matrix for f₁.
 - `p2`: Exponent for f₂ (1 < p < 2).
 - `λ2`: Parameter for f₂.
 - `Φ2`: Linear transformation matrix for f₂.
"""
function AAS2(; T::Type{<:AbstractFloat}=Float64,
    p1=1.003,
    λ1=1.2,
    Φ1=[1.2 -0.3; 0.4 1.5],
    c1=[1.5; -1.0],
    p2=1.003,
    λ2=0.8,
    Φ2=[1.8 0.5; -0.2 1.1],
    c2=[-1.2; 0.8]
)
    meta = META["AAS2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Convert parameters to type T
    Φ1_T = T.(Φ1)
    p1_T = T(p1)
    λ1_T = T(λ1)
    c1_T = T.(c1)
    Φ2_T = T.(Φ2)
    p2_T = T(p2)
    λ2_T = T(λ2)
    c2_T = T.(c2)

    f1 = x -> begin
        Φx = Φ1_T * (x - c1_T)
        return (λ1_T / p1_T) * (abs(Φx[1])^p1_T + abs(Φx[2])^p1_T)
    end

    f2 = x -> begin
        Φx = Φ2_T * (x - c2_T)
        return (λ2_T / p2_T) * (abs(Φx[1])^p2_T + abs(Φx[2])^p2_T)
    end

    # grad_f1 = x -> begin
    #     Φx = Φ1_T * x
    #     grad_norm = [sign(Φx[1]) * abs(Φx[1])^(p1_T - 1),
    #                  sign(Φx[2]) * abs(Φx[2])^(p1_T - 1)]
    #     return λ1_T * Φ1_T' * grad_norm
    # end

    # grad_f2 = x -> begin
    #     Φx = Φ2_T * x
    #     grad_norm = [sign(Φx[1]) * abs(Φx[1])^(p2_T - 1),
    #                  sign(Φx[2]) * abs(Φx[2])^(p2_T - 1)]
    #     return λ2_T * Φ2_T' * grad_norm
    # end

    # jacobian = x -> [grad_f1(x)'; grad_f2(x)']

    return MOProblem(
        n,
        m,
        [f1, f2];
        name=meta[:name],
        origin=meta[:origin],
        minimize=meta[:minimize],
        has_bounds=meta[:has_bounds],
        bounds=(fill(T(-5.0), n), fill(T(5.0), n)), #TODO: Is this really necessary? Why does this problem have bounds?
        has_jacobian=false,
        # jacobian=jacobian,
        # jacobian_by_row=[grad_f1, grad_f2],
        convexity=meta[:convexity]
    )
end 