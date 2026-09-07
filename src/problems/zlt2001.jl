"""
    ZLT1(; n::Int = 100, m::Int = 2)

Construct the independent-dimension `ZLT1` problem.

`n` is the number of variables and `m` the number of objectives; they must
satisfy `m >= 2` and `n >= m`. Their default values are `n = 100` and `m = 2`.
The variables are bounded in `[-1000, 1000]^n`. An analytical Jacobian is
registered; objective Hessians are not registered.
"""
function ZLT1(; n::Int = 100, m::Int = 2)
    m >= 2 || throw(ArgumentError("m must be at least 2 for ZLT1"))
    n >= m || throw(ArgumentError("n must be at least m for ZLT1"))
    meta = META["ZLT1"]

    objectives = ntuple(m) do idx
        function (x::AbstractVector{T}) where {T <: AbstractFloat}
            s = (x[idx] - one(T))^2
            @inbounds for i in 1:n
                if i != idx
                    s += x[i]^2
                end
            end
            return s
        end
    end

    gradients = ntuple(m) do idx
        function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            @inbounds for i in 1:n
                grad[i] = T(2) * x[i]
            end
            # Overwrite the shifted coordinate, whose derivative is 2 * (x[idx] - 1).
            grad[idx] = T(2) * (x[idx] - one(T))
            return grad
        end
    end

    return MOProblem(
        n, m, objectives;
        name = meta.name,
        bounds = (fill(-1000.0, n), fill(1000.0, n)),
        jacobian = gradients,
    )
end
