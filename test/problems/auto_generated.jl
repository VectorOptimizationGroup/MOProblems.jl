using Test
using MOProblems
using .TestUtils

@testset "All problems (auto)" begin
    names = sort(MOProblems.get_problem_names())
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
                    x = TestUtils.sample_x(prob)
                    vals = MOProblems.eval_f(prob, x)
                    J = MOProblems.eval_jacobian(prob, x)
                    @test length(vals) == prob.nobj
                    @test size(J) == (prob.nobj, prob.nvar)
                    if prob.has_jacobian && !isnothing(prob.jacobian)
                        ok, _ = TestUtils.check_jacobian(y -> MOProblems.eval_f(prob, y), y -> MOProblems.eval_jacobian(prob, y), x)
                        @test ok
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
                x = TestUtils.sample_x(prob)
                vals = MOProblems.eval_f(prob, x)
                J = MOProblems.eval_jacobian(prob, x)
                @test length(vals) == prob.nobj
                @test size(J) == (prob.nobj, prob.nvar)
                if prob.has_jacobian && !isnothing(prob.jacobian)
                    ok, _ = TestUtils.check_jacobian(y -> MOProblems.eval_f(prob, y), y -> MOProblems.eval_jacobian(prob, y), x)
                    @test ok
                end
            end
        end
    end
end
