using Test
using MOProblems
using .TestUtils

@testset "Extended Stress Suites" begin
    # Dimensões maiores e mais amostras; execute apenas com MO_EXTENDED=1
    Ns = TestUtils.dims_full()
    # Testar alguns problemas escaláveis
    for name in ("ZDT1", "ZDT2", "DTLZ1", "DTLZ2")
        if !(name in MOProblems.get_problem_names())
            continue
        end
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
                @test length(vals) == prob.nobj
                if !isnothing(prob.jacobian)
                    J = MOProblems.eval_jacobian(prob, x)
                    @test size(J) == (prob.nobj, prob.nvar)
                    ok, _ = TestUtils.check_jacobian(y -> MOProblems.eval_f(prob, y), y -> MOProblems.eval_jacobian(prob, y), x)
                    @test ok
                else
                    @test_throws ErrorException MOProblems.eval_jacobian(prob, x)
                end
            end
        end
    end
end
