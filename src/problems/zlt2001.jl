"""
    ZLT1()

Problem characteristics summary:
- 10 variables
- 5 objectives
- Objectives:
    fₘ(x) = (xₘ - 1)² + ∑ᵢ₌₁,ᵢ≠ₘⁿ xᵢ², for m = 1,...,M
- Bounds: [-1000, 1000] for all variables
- Convexity: convex for all objectives

Reference:
Zitzler, E., Laumanns, M., Thiele, L. (2001).
SPEA2: Improving the strength Pareto evolutionary algorithm. https://doi.org/10.3929/ethz-a-004284029
"""
function ZLT1()
    meta = META["ZLT1"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

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
