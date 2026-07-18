"""
    FDS(n::Int = 5)

Construct the scalable `n`-variable, three-objective `FDS` problem.

The dimension must satisfy `n >= 1`; the default is `n = 5`. The variables are
bounded in `[-2, 2]^n`. An analytical Jacobian is registered; objective Hessians
are not registered.
"""
function FDS(n::Int = 5)
    n >= 1 || throw(ArgumentError("n must be at least 1 for FDS"))
    meta = META["FDS"]
    m = default_nobj(meta)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * (x[i] - T(i))^4
        end
        return sum_val / (T(n)^2)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x = zero(T)
        norm2 = zero(T)
        for i in 1:n
            sum_x += x[i]
            norm2 += x[i]^2
        end
        return exp(sum_x / T(n)) + norm2
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_val = zero(T)
        for i in 1:n
            sum_val += T(i) * T(n - i + 1) * exp(-x[i])
        end
        return sum_val / (T(n) * T(n + 1))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = T(4) * T(i) * (x[i] - T(i))^3 / (T(n)^2)
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_x = zero(T)
        for i in 1:n
            sum_x += x[i]
        end
        exp_term = exp(sum_x / T(n))
        for i in 1:n
            grad[i] = exp_term / T(n) + T(2) * x[i]
        end
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        for i in 1:n
            grad[i] = -T(i) * T(n - i + 1) * exp(-x[i]) / (T(n) * T(n + 1))
        end
        return grad
    end

    bounds = (fill(-2.0, n), fill(2.0, n))

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = bounds,
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end