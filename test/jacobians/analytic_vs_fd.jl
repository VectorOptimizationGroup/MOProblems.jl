using Test
using MOProblems
using .TestUtils

@testset "Jacobian: analytic vs FD" begin
    names = MOProblems.filter_problems(has_jacobian=true)
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
                    if !prob.has_jacobian || isnothing(prob.jacobian)
                        continue
                    end
                    x = TestUtils.sample_x(prob)
                    f = y -> MOProblems.eval_f(prob, y)
                    J = y -> MOProblems.eval_jacobian(prob, y)
                    ok, err = TestUtils.check_jacobian(f, J, x)
                    @info "Jacobian check" name=name n=prob.nvar relerr=err
                    @test ok
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
                if !prob.has_jacobian || isnothing(prob.jacobian)
                    continue
                end
                x = TestUtils.sample_x(prob)
                f = y -> MOProblems.eval_f(prob, y)
                J = y -> MOProblems.eval_jacobian(prob, y)
                ok, err = TestUtils.check_jacobian(f, J, x)
                @info "Jacobian check" name=name n=prob.nvar relerr=err
                @test ok
            end
        end
    end
end
