"""
    Problemas DGO (Dumitrescu, Grosan, Oltean, 2000)

Referência:
- D. Dumitrescu, C. Grosan, and M. Oltean, "A new evolutionary approach for multiobjective optimization," Studia Universitatis Babes-Bolyai, Informatica, vol. XLV, no. 1, pp. 51–68, 2000.

Note: The naming convention DGO1 and DGO2 has been established in the literature over the years,
but these correspond to Examples 2 and 3 in the original paper. DGO0 corresponds to Example 1.
"""
# ------------------------- DGO0 -------------------------
"""
    DGO0()

Problema DGO0 - Exemplo 1 do artigo original (Example 1 in the original paper).

Características:
- 1 variável
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁²
  - f₂(x) = (x₁ - 2)²
- Limites: [-4, 6]
- Convexidade: [estritamente convexa, estritamente convexa]
"""
function DGO0(; T::Type{<:AbstractFloat}=Float64)
    meta = META["DGO0"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Funções objetivo
    f1 = x -> x[1]^2
    f2 = x -> (x[1] - T(2.0))^2

    # Gradientes
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * x[1]
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * (x[1] - T(2.0))
        return grad
    end

    # Jacobiana completa (2 × 1)
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    # Criar o problema
    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-4.0), n), fill(T(6.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- DGO1 -------------------------
"""
    DGO1()

Problema DGO1 - Funções seno com deslocamento de fase.

Características:
- 1 variável
- 2 funções objetivo
- Objetivos:
  - f₁(x) = sin(x₁)
  - f₂(x) = sin(x₁ + 0.7)
- Limites: [-10, 13]
- Convexidade: [não convexa, não convexa]
"""
function DGO1(; T::Type{<:AbstractFloat}=Float64)
    meta = META["DGO1"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Funções objetivo
    f1 = x -> sin(x[1])
    f2 = x -> sin(x[1] + T(0.7))

    # Gradientes
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = cos(x[1])
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = cos(x[1] + T(0.7))
        return grad
    end

    # Jacobiana completa (2 × 1)
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    # Criar o problema
    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-10.0), n), fill(T(13.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end

# ------------------------- DGO2 -------------------------
"""
    DGO2()

Problema DGO2 - Função quadrática e função com raiz quadrada.

Características:
- 1 variável
- 2 funções objetivo
- Objetivos:
  - f₁(x) = x₁²
  - f₂(x) = 9 - √(81 - x₁²)
- Limites: [-9, 9]
- Convexidade: [estritamente convexa, estritamente convexa]
"""
function DGO2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["DGO2"]
    n = meta[:nvar]
    m = meta[:nobj]

    # Funções objetivo
    f1 = x -> x[1]^2
    f2 = x -> T(9.0) - sqrt(T(81.0) - x[1]^2)

    # Gradientes
    df1_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = T(2.0) * x[1]
        return grad
    end

    df2_dx = x -> begin
        grad = zeros(T, n)
        grad[1] = x[1] / sqrt(T(81.0) - x[1]^2)
        return grad
    end

    # Jacobiana completa (2 × 1)
    jacobian = x -> [df1_dx(x)'; df2_dx(x)']

    # Criar o problema
    return MOProblem(
        n,
        m,
        [f1, f2];
        name = meta[:name],
        origin = meta[:origin],
        minimize = meta[:minimize],
        has_bounds = meta[:has_bounds],
        bounds = (fill(T(-9.0), n), fill(T(9.0), n)),
        has_jacobian = true,
        jacobian = jacobian,
        jacobian_by_row = [df1_dx, df2_dx],
        convexity = meta[:convexity]
    )
end 