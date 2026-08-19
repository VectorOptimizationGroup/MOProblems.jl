"""
    QV1(n::Int = 16)

Construct the variable-dimension, two-objective `QV1` problem.

The dimension parameter must satisfy `n >= 1`; its default is `n = 16`. The
variables are bounded in `[-5.12, 5.12]^n`. An analytical Jacobian is
registered; objective Hessians are not registered. Both objective values are
defined throughout the box, but the first Jacobian row is undefined at
`x == zeros(n)` and the second at `x == fill(1.5, n)`. Evaluating an undefined
row throws a `DomainError`.
"""
function QV1(n::Int = 16)
    n >= 1 || throw(ArgumentError("n must be at least 1 for QV1"))
    meta = META["QV1"]
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            s += x[i]^2 - T(10) * cos(twoπ * x[i]) + T(10)
        end
        return (s / T(n))^T(0.25)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            s += y^2 - T(10) * cos(twoπ * y) + T(10)
        end
        return (s / T(n))^T(0.25)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        all(iszero, x) && throw(DomainError(
            Tuple(x),
            "QV1 Jacobian row 1 is undefined at the first objective minimizer " *
            "(0, ..., 0).",
        ))

        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            s += x[i]^2 - T(10) * cos(twoπ * x[i]) + T(10)
        end

        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        @inbounds for i in 1:n
            grad[i] = factor * (T(2) * x[i] + T(20) * T(π) * sin(twoπ * x[i]))
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        all(==(T(1.5)), x) && throw(DomainError(
            Tuple(x),
            "QV1 Jacobian row 2 is undefined at the second objective minimizer " *
            "(1.5, ..., 1.5).",
        ))

        twoπ = T(2) * T(π)
        s = zero(T)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            s += y^2 - T(10) * cos(twoπ * y) + T(10)
        end

        factor = T(0.25) * (s / T(n))^(-T(0.75)) / T(n)
        @inbounds for i in 1:n
            y = x[i] - T(1.5)
            grad[i] = factor * (T(2) * y + T(20) * T(π) * sin(twoπ * y))
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-5.12, n), fill(5.12, n)),
        jacobian = (df1_dx, df2_dx),
    )
end
