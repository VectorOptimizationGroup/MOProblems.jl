"""
    Examples 1 from the paper: Amaral, V.S. & Assunção, P.B. & Souza, D.R. (2025): A Derivative-Free Proximal Method with Quadratic Modeling for Composite Multiobjective Optimization in the H¨older Setting
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
    AAS2(; T::Type{<:AbstractFloat}=Float64,
         p1=1.003, λ1=1.2, Φ1=[1.2 -0.3; 0.4 1.5], c1=[1.5; -1.0],
         p2=1.002, λ2=0.8, Φ2=[1.8 0.5; -0.2 1.1], c2=[-1.2; 0.8])

A function with two Hölder continuous gradient functions.

Características:
- Número de variáveis: 2 (fixo)
- Número de objetivos: 2
- Domínio: [-5, 5]²
- Fronteira de Pareto: depende dos parâmetros
- Objetivos: ambos convexos com gradientes Hölder contínuos

Fórmulas:
- f₁(x) = (λ₁/p₁) * ||Φ₁(x - c₁)||ₚ₁ᵖ¹
- f₂(x) = (λ₂/p₂) * ||Φ₂(x - c₂)||ₚ₂ᵖ²

# Argumentos
- `T`: Tipo de ponto flutuante a usar (default: Float64)
- `p1`: Expoente para f₁ (1 < p₁ < 2, default: 1.003)
- `λ1`: Parâmetro para f₁ (default: 1.2)
- `Φ1`: Matriz de transformação linear para f₁ (default: [1.2 -0.3; 0.4 1.5])
- `c1`: Centro para f₁ (default: [1.5; -1.0])
- `p2`: Expoente para f₂ (1 < p₂ < 2, default: 1.002)
- `λ2`: Parâmetro para f₂ (default: 0.8)
- `Φ2`: Matriz de transformação linear para f₂ (default: [1.8 0.5; -0.2 1.1])
- `c2`: Centro para f₂ (default: [-1.2; 0.8])

# Exemplo
```julia
# Problema padrão
problem = AAS2()

# Problema personalizado
problem = AAS2(p1=1.5, λ1=2.0, p2=1.8, λ2=1.5)
```
"""
function AAS2(; T::Type{<:AbstractFloat}=Float64,
    p1=1.003,
    λ1=1.2,
    Φ1=[1.2 -0.3; 0.4 1.5],
    c1=[1.5; -1.0],
    p2=1.002,
    λ2=0.8,
    Φ2=[1.8 0.5; -0.2 1.1],
    c2=[-1.2; 0.8]
)
    # Validações dos parâmetros
    @assert 1 < p1 < 2 "p1 deve estar no intervalo (1, 2)"
    @assert 1 < p2 < 2 "p2 deve estar no intervalo (1, 2)"
    @assert λ1 > 0 "λ1 deve ser positivo"
    @assert λ2 > 0 "λ2 deve ser positivo"
    @assert size(Φ1) == (2, 2) "Φ1 deve ser uma matriz 2x2"
    @assert size(Φ2) == (2, 2) "Φ2 deve ser uma matriz 2x2"
    @assert length(c1) == 2 "c1 deve ser um vetor de dimensão 2"
    @assert length(c2) == 2 "c2 deve ser um vetor de dimensão 2"

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

    # Primeira função objetivo: f₁(x) = (λ₁/p₁) * ||Φ₁(x - c₁)||ₚ₁ᵖ¹
    f1 = x -> begin
        Φx = Φ1_T * (x - c1_T)
        return (λ1_T / p1_T) * (abs(Φx[1])^p1_T + abs(Φx[2])^p1_T)
    end

    # Segunda função objetivo: f₂(x) = (λ₂/p₂) * ||Φ₂(x - c₂)||ₚ₂ᵖ²
    f2 = x -> begin
        Φx = Φ2_T * (x - c2_T)
        return (λ2_T / p2_T) * (abs(Φx[1])^p2_T + abs(Φx[2])^p2_T)
    end

    return MOProblem{T}(
        n,
        m,
        [f1, f2];
        name=meta[:name],
        origin=meta[:origin],
        minimize=meta[:minimize],
        has_bounds=meta[:has_bounds],
        bounds=(fill(T(-5.0), n), fill(T(5.0), n)), # The minimum of each function can be found within the box
        has_jacobian=false,
        convexity=meta[:convexity]
    )
end 