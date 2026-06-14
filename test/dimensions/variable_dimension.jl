using Test
using MOProblems
using .TestUtils

@testset "Variable Dimension" begin
    names = sort(MOProblems.get_problem_names())
    for name in names
        meta = MOProblems.META[name]
        if meta.variable_nvar
            for n in TestUtils.dims()
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
                        f = y -> MOProblems.eval_f(prob, y)
                        G = y -> MOProblems.eval_jacobian(prob, y)
                        ok, _ = TestUtils.check_jacobian(f, G, x)
                        @test ok
                    else
                        @test_throws ErrorException MOProblems.eval_jacobian(prob, x)
                    end
                end
            end
        end
    end
end
