module TestUtils

using Test
using Random
using LinearAlgebra
using FiniteDiff
using MOProblems

export instantiate_with_dimension, sample_x, check_jacobian, dims

const FAST = get(ENV, "MO_FAST", "1") == "1"
dims_fast() = (5, 10)
dims_full() = (5, 10, 20, 30, 50)
dims() = FAST ? dims_fast() : dims_full()

const ATOL = 1e-8
const RTOL = 1e-6

relok(A, B; atol=ATOL, rtol=RTOL) = (norm(A - B) / max(norm(B), atol)) <= rtol

function sample_x(prob::MOProblems.MOProblem; rng=Random.MersenneTwister(42))
    n = prob.nvar
    if !isnothing(prob.bounds)
        l, u = prob.bounds
        x = zeros(Float64, n)
        for i in 1:n
            li = isinf(l[i]) ? -5.0 : Float64(l[i])
            ui = isinf(u[i]) ? 5.0 : Float64(u[i])
            if !(li < ui)
                li, ui = min(li, ui) - 1.0, max(li, ui) + 1.0
            end
            x[i] = li + rand(rng) * (ui - li)
        end
        return x
    else
        return rand(rng, n) .* 2 .- 1
    end
end

function check_jacobian(f, J, x; atol=ATOL, rtol=RTOL)
    Jfd = FiniteDiff.finite_difference_jacobian(f, x, Val(:central))
    Jx = J(x)
    ok = relok(Jx, Jfd; atol=atol, rtol=rtol)
    return ok, norm(Jx - Jfd) / max(norm(Jfd), atol)
end

function instantiate_with_dimension(name::String, n::Int)
    constructor = getfield(MOProblems, Symbol(name))
    if startswith(name, "ZDT")
        return constructor(n; T=Float64)
    elseif name == "QV1"
        return constructor(n; T=Float64)
    elseif startswith(name, "DTLZ")
        m = 3
        k = max(1, n - m + 1)
        if name == "DTLZ4"
            return constructor(k=k, m=m, alpha=2.0, T=Float64)
        else
            return constructor(k=k, m=m, T=Float64)
        end
    else
        try
            return constructor(n; T=Float64)
        catch
            return constructor(T=Float64)
        end
    end
end

end # module
