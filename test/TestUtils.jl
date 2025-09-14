module TestUtils

using Test
using Random
using LinearAlgebra
using FiniteDiff
using MOProblems

const FAST = get(ENV, "MO_FAST", "1") == "1"
dims_fast() = (5, 10)
dims_full() = (5, 10, 20, 30, 50)
dims() = FAST ? dims_fast() : dims_full()

const ATOL = 1e-8
const RTOL = 1e-6

relok(A, B; atol=ATOL, rtol=RTOL) = (norm(A - B) / max(norm(B), atol)) <= rtol

function sample_x(prob::MOProblems.AbstractMOProblem; rng=Random.MersenneTwister(42))
    n = prob.nvar
    if prob.has_bounds
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
    if startswith(name, "ZDT")
        return MOProblems.instantiate(name, n; T=Float64)
    elseif name == "QV1"
        return MOProblems.instantiate(name, n; T=Float64)
    elseif startswith(name, "DTLZ")
        m = 3
        k = max(1, n - m + 1)
        if name == "DTLZ4"
            return MOProblems.instantiate(name; k=k, m=m, alpha=2.0, T=Float64)
        else
            return MOProblems.instantiate(name; k=k, m=m, T=Float64)
        end
    else
        try
            return MOProblems.instantiate(name, n; T=Float64)
        catch
            return MOProblems.instantiate(name; T=Float64)
        end
    end
end

end # module
