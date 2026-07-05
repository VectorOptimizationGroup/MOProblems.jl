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
"""
function DGO0()
    meta = META["DGO0"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(2))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] - T(2))
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-4.0, n), fill(6.0, n)),
        jacobian = (df1_dx, df2_dx),
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
"""
function DGO1()
    meta = META["DGO1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return sin(x[1])
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return sin(x[1] + T(0.7))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = cos(x[1])
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = cos(x[1] + T(0.7))
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-10.0, n), fill(13.0, n)),
        jacobian = (df1_dx, df2_dx),
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
"""
function DGO2()
    meta = META["DGO2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(9) - sqrt(T(81) - x[1]^2)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = x[1] / sqrt(T(81) - x[1]^2)
        return grad
    end

    return MOProblem(
        n,
        m,
        (f1, f2);
        name = meta.name,
        bounds = (fill(-9.0, n), fill(9.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end