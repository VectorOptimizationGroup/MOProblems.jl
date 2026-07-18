"""
J. J. Moré, B. S. Garbow, K. E. Hillstrom, Testing Unconstrained Optimization
Software, ACM Transactions on Mathematical Software, 7(1):17-41, 1981.
DOI: 10.1145/355934.355936
"""

# ------------------------- MGH9 -------------------------
"""
    MGH9()

Problem characteristics summary:
- 3 variables
- 15 objectives
- Objectives:
    fᵢ(x) = x₁ exp(-x₂(tᵢ - x₃)² / 2) - yᵢ, i = 1, ..., 15
- Bounds: [-2, 2] for all variables
"""
function MGH9()
    meta = META["MGH9"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    tdata = ntuple(i -> (8.0 - i) / 2.0, m)
    ydata = (
        9.0e-4,
        4.4e-3,
        1.75e-2,
        5.4e-2,
        1.295e-1,
        2.42e-1,
        3.521e-1,
        3.989e-1,
        3.521e-1,
        2.42e-1,
        1.295e-1,
        5.4e-2,
        1.75e-2,
        4.4e-3,
        9.0e-4,
    )

    objectives = ntuple(i -> function (x::AbstractVector{T}) where {T <: AbstractFloat}
        z = T(tdata[i]) - x[3]
        return x[1] * exp(-x[2] * z^2 / T(2)) - T(ydata[i])
    end, m)

    gradients = ntuple(i -> function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        z = T(tdata[i]) - x[3]
        e = exp(-x[2] * z^2 / T(2))
        grad[1] = e
        grad[2] = -x[1] * e * z^2 / T(2)
        grad[3] = x[1] * e * x[2] * z
        return grad
    end, m)

    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (fill(-2.0, n), fill(2.0, n)),
        jacobian = gradients,
    )
end

# ------------------------- MGH16 -------------------------
"""
    MGH16()

Problem characteristics summary:
- 4 variables
- 5 objectives
- Objectives:
    fᵢ(x) = (x₁ + tᵢx₂ - exp(tᵢ))² + (x₃ + x₄sin(tᵢ) - cos(tᵢ))²,
    where tᵢ = i / 5, i = 1, ..., 5
- Bounds: x₁ in [-25, 25], x₂ and x₃ in [-5, 5], x₄ in [-1, 1]
"""
function MGH16()
    meta = META["MGH16"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    tdata = ntuple(i -> i / 5, m)

    objectives = ntuple(i -> function (x::AbstractVector{T}) where {T <: AbstractFloat}
        ti = T(tdata[i])
        a = x[1] + ti * x[2] - exp(ti)
        b = x[3] + x[4] * sin(ti) - cos(ti)
        return a^2 + b^2
    end, m)

    gradients = ntuple(i -> function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        ti = T(tdata[i])
        s = sin(ti)
        a = x[1] + ti * x[2] - exp(ti)
        b = x[3] + x[4] * s - cos(ti)
        grad[1] = T(2) * a
        grad[2] = T(2) * ti * a
        grad[3] = T(2) * b
        grad[4] = T(2) * s * b
        return grad
    end, m)

    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = ([-25.0, -5.0, -5.0, -1.0], [25.0, 5.0, 5.0, 1.0]),
        jacobian = gradients,
    )
end

# ------------------------- MGH26 -------------------------
"""
    MGH26(; n::Int = 4)

Problem characteristics summary:
- `n` variables
- `n` objectives
- Objectives:
    fᵢ(x) = (n - ∑ⱼcos(xⱼ) + i(1 - cos(xᵢ)) - sin(xᵢ))², i = 1, ..., n
- Bounds: [-1, 1] for all variables
"""
function MGH26(; n::Int = 4)
    n >= 1 || throw(ArgumentError("n must be at least 1 for MGH26"))
    m = n
    meta = META["MGH26"]

    objectives = Vector{Function}(undef, m)
    for i in 1:m
        objectives[i] = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            sum_cos = zero(T)
            @inbounds for k in 1:n
                sum_cos += cos(x[k])
            end
            h = T(n) - sum_cos + T(i) * (one(T) - cos(x[i])) - sin(x[i])
            return h^2
        end
    end

    gradients = Vector{Function}(undef, m)
    for i in 1:m
        gradients[i] = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            sum_cos = zero(T)
            @inbounds for k in 1:n
                sum_cos += cos(x[k])
            end

            h = T(n) - sum_cos + T(i) * (one(T) - cos(x[i])) - sin(x[i])
            scale = T(2) * h

            @inbounds for k in 1:n
                grad[k] = scale * sin(x[k])
            end
            grad[i] += scale * (T(i) * sin(x[i]) - cos(x[i]))
            return grad
        end
    end

    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = gradients,
    )
end

# ------------------------- MGH33 -------------------------
"""
    MGH33()

Problem characteristics summary:
- 10 variables
- 10 objectives
- Objectives:
    fᵢ(x) = (i∑ⱼjxⱼ - 1)², i = 1, ..., 10
- Bounds: [-1, 1] for all variables
"""
function MGH33()
    meta = META["MGH33"]
    n = default_nvar(meta)
    m = default_nobj(meta)

    objectives = ntuple(i -> function (x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for j in 1:n
            s += T(j) * x[j]
        end
        h = T(i) * s - one(T)
        return h^2
    end, m)

    gradients = ntuple(i -> function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        s = zero(T)
        @inbounds for j in 1:n
            s += T(j) * x[j]
        end

        h = T(i) * s - one(T)
        scale = T(2) * h * T(i)
        @inbounds for j in 1:n
            grad[j] = scale * T(j)
        end
        return grad
    end, m)

    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = gradients,
    )
end
