using Test
using LinearAlgebra
using FiniteDiff
using MOProblems
using .TestUtils

function grid_points(prob::MOProblems.AbstractMOProblem)
    n = prob.nvar
    if n <= 2
        # Pequena malha regular por dimensão (3 níveis)
        levels = Vector{Vector{Float64}}(undef, n)
        if prob.has_bounds
            l, u = prob.bounds
            for i in 1:n
                li = isinf(l[i]) ? -2.0 : Float64(l[i])
                ui = isinf(u[i]) ?  2.0 : Float64(u[i])
                if !(li < ui)
                    li, ui = min(li, ui) - 1.0, max(li, ui) + 1.0
                end
                levels[i] = [li + t * (ui - li) for t in (0.25, 0.5, 0.75)]
            end
        else
            for i in 1:n
                levels[i] = [-0.5, 0.0, 0.5]
            end
        end

        pts = Vector{Vector{Float64}}()
        for tup in Iterators.product(levels...)
            push!(pts, collect(tup))
        end
        return pts
    else
        # Para dimensões maiores, usar um único ponto de amostragem rápido
        return [TestUtils.sample_x(prob)]
    end
end

@testset "Hessian: analytic vs FD" begin
    names = MOProblems.filter_problems(has_hessian=true)
    for name in names
        meta = MOProblems.META[name]
        variable = get(meta, :variable_nvar, false)
        Ns = variable ? TestUtils.dims() : ()

        if variable
            for n in Ns
                @testset "$(name) n=$(n)" begin
                    local prob
                    try
                        prob = TestUtils.instantiate_with_dimension(name, n)
                    catch e
                        @error "Falha ao instanciar" name=name n=n error=e
                        @test false
                        continue
                    end
                    if !prob.has_hessian
                        continue
                    end
                    for (k, x) in enumerate(grid_points(prob))
                        for i in 1:prob.nobj
                            fi = y -> MOProblems.eval_f(prob, y, i)
                            Hfd = FiniteDiff.finite_difference_hessian(fi, x, Val(:hcentral))
                            Hx = MOProblems.eval_hessian_row(prob, x, i)
                            ok = TestUtils.relok(Hx, Hfd)
                            relerr = norm(Hx - Hfd) / max(norm(Hfd), TestUtils.ATOL)
                            @info "Hessian check" name=name n=prob.nvar obj=i point=k relerr=relerr
                            @test ok
                        end
                    end
                end
            end
        else
            @testset "$(name) default" begin
                local prob
                try
                    prob = MOProblems.instantiate(name; T=Float64)
                catch e
                    @error "Falha ao instanciar" name=name error=e
                    @test false
                    continue
                end
                if !prob.has_hessian
                    continue
                end
                for (k, x) in enumerate(grid_points(prob))
                    for i in 1:prob.nobj
                        fi = y -> MOProblems.eval_f(prob, y, i)
                        Hfd = FiniteDiff.finite_difference_hessian(fi, x, Val(:hcentral))
                        Hx = MOProblems.eval_hessian_row(prob, x, i)
                        ok = TestUtils.relok(Hx, Hfd)
                        relerr = norm(Hx - Hfd) / max(norm(Hfd), TestUtils.ATOL)
                        @info "Hessian check" name=name n=prob.nvar obj=i point=k relerr=relerr
                        @test ok
                    end
                end
            end
        end
    end
end
