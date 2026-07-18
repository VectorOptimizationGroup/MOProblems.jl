"""
Toint, P. L. (1983). Test problems for partially separable optimization and results for the routine PSPMIN.
Technical Report, University of Namur, Department of Mathematics, Belgium. https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf

See also:
Mita, K., Fukuda, E. H., & Yamashita, N. (2019). Nonmonotone line searches for unconstrained
multiobjective optimization problems. Journal of Global Optimization, 75, 63-90.
https://doi.org/10.1007/s10898-019-00802-0
"""

# ------------------------- Toi4 -------------------------
"""
    Toi4()

Problem characteristics summary:
- 4 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁² + x₂² + 1
    f₂(x) = 0.5((x₁ - x₂)² + (x₃ - x₄)²) + 1
- Bounds: [-2, 5] for all variables
"""
function Toi4()
    meta = META["Toi4"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]^2 + x[2]^2 + one(T)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(0.5) * ((x[1] - x[2])^2 + (x[3] - x[4])^2) + one(T)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * x[1]
        grad[2] = T(2) * x[2]
        grad[3] = zero(T)
        grad[4] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        diff12 = x[1] - x[2]
        diff34 = x[3] - x[4]
        grad[1] = diff12
        grad[2] = -diff12
        grad[3] = diff34
        grad[4] = -diff34
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-2.0, n), fill(5.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- Toi8 -------------------------
"""
    Toi8()

Problem characteristics summary:
- 3 variables
- 3 objectives
- Objectives:
    f₁(x) = (2x₁ - 1)²
    fᵢ(x) = i(2xᵢ₋₁ - xᵢ)², i = 2, 3
- Bounds: [-1, 1] for all variables
"""
function Toi8()
    meta = META["Toi8"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (T(2) * x[1] - one(T))^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(2) * (T(2) * x[1] - x[2])^2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return T(3) * (T(2) * x[2] - x[3])^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(4) * (T(2) * x[1] - one(T))
        grad[2] = zero(T)
        grad[3] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        diff = T(2) * x[1] - x[2]
        grad[1] = T(8) * diff
        grad[2] = -T(4) * diff
        grad[3] = zero(T)
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        diff = T(2) * x[2] - x[3]
        grad[1] = zero(T)
        grad[2] = T(12) * diff
        grad[3] = -T(6) * diff
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end

# ------------------------- Toi9 -------------------------
"""
    Toi9(; n::Int = 4)

Problem characteristics summary:
- `n` variables
- `n` objectives
- Objectives:
    f₁(x) = (2x₁ - 1)² + x₂²
    fᵢ(x) = i(2xᵢ₋₁ - xᵢ)² - (i - 1)xᵢ₋₁² + ixᵢ², 2 <= i < n
    fₙ(x) = n(2xₙ₋₁ - xₙ)² - (n - 1)xₙ₋₁²
- Bounds: [-1, 1] for all variables
"""
function Toi9(; n::Int = 4)
    n >= 2 || throw(ArgumentError("n must be at least 2 for Toi9"))
    m = n
    meta = META["Toi9"]

    f_list = Vector{Function}(undef, m)
    for idx in 1:m
        f_list[idx] = let idx = idx
            if idx == 1
                function (x::AbstractVector{T}) where {T <: AbstractFloat}
                    return (T(2) * x[1] - one(T))^2 + x[2]^2
                end
            elseif idx < n
                function (x::AbstractVector{T}) where {T <: AbstractFloat}
                    diff = T(2) * x[idx - 1] - x[idx]
                    return T(idx) * diff^2 - T(idx - 1) * x[idx - 1]^2 + T(idx) * x[idx]^2
                end
            else
                function (x::AbstractVector{T}) where {T <: AbstractFloat}
                    diff = T(2) * x[n - 1] - x[n]
                    return T(n) * diff^2 - T(n - 1) * x[n - 1]^2
                end
            end
        end
    end

    jac_rows = Vector{Function}(undef, m)
    for idx in 1:m
        jac_rows[idx] = let idx = idx
            if idx == 1
                function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
                    fill!(grad, zero(T))
                    grad[1] = T(4) * (T(2) * x[1] - one(T))
                    grad[2] = T(2) * x[2]
                    return grad
                end
            elseif idx < n
                function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
                    fill!(grad, zero(T))
                    diff = T(2) * x[idx - 1] - x[idx]
                    grad[idx - 1] = T(4) * T(idx) * diff - T(2) * T(idx - 1) * x[idx - 1]
                    grad[idx] = -T(2) * T(idx) * diff + T(2) * T(idx) * x[idx]
                    return grad
                end
            else
                function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
                    fill!(grad, zero(T))
                    diff = T(2) * x[n - 1] - x[n]
                    grad[n - 1] = T(4) * T(n) * diff - T(2) * T(n - 1) * x[n - 1]
                    grad[n] = -T(2) * T(n) * diff
                    return grad
                end
            end
        end
    end

    return MOProblem(
        n, m, f_list;
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = jac_rows,
    )
end

# ------------------------- Toi10 -------------------------
"""
    Toi10(; n::Int = 4)

Problem characteristics summary:
- `n` variables
- `n - 1` objectives
- Objectives:
    fᵢ(x) = 100(xᵢ₊₁ - xᵢ²)² + (xᵢ₊₁ - 1)², i = 1, ..., n - 1
- Bounds: [-2, 2] for all variables
"""
function Toi10(; n::Int = 4)
    n >= 2 || throw(ArgumentError("n must be at least 2 for Toi10"))
    meta = META["Toi10"]
    m = n - 1

    f_rows = Vector{Function}(undef, m)
    for idx in 1:m
        f_rows[idx] = let idx = idx
            function (x::AbstractVector{T}) where {T <: AbstractFloat}
                diff = x[idx + 1] - x[idx]^2
                return T(100) * diff^2 + (x[idx + 1] - one(T))^2
            end
        end
    end

    jac_rows = Vector{Function}(undef, m)
    for idx in 1:m
        jac_rows[idx] = let idx = idx
            function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
                fill!(grad, zero(T))
                diff = x[idx + 1] - x[idx]^2
                grad[idx] = -T(400) * diff * x[idx]
                grad[idx + 1] = T(200) * diff + T(2) * (x[idx + 1] - one(T))
                return grad
            end
        end
    end

    return MOProblem(
        n, m, f_rows;
        name = meta.name,
        bounds = (fill(-2.0, n), fill(2.0, n)),
        jacobian = jac_rows,
    )
end