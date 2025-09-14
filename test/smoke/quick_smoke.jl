using Test
using MOProblems
using .TestUtils

@testset "Quick Smoke" begin
    # Escolher poucos problemas para rodar rápido
    for name in ("AP1", "MOP2", "ZDT1")
        @testset "Smoke: $(name)" begin
            local prob
            try
                if startswith(name, "ZDT")
                    prob = TestUtils.instantiate_with_dimension(name, first(TestUtils.dims()))
                else
                    prob = MOProblems.instantiate(name; T=Float64)
                end
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
        end
    end
end
