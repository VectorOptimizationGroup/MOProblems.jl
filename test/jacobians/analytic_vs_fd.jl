using Test
using MOProblems
using .TestUtils

@testset "Jacobian: analytic vs FD" begin
    names = MOProblems.filter_problems(has_jacobian=true)
    for name in names
        meta = MOProblems.META[name]
        variable = !(meta.dimension isa FixedDimension)
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
                    if isnothing(prob.jacobian)
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
                    prob = getfield(MOProblems, Symbol(name))()
                catch e
                    @error "Falha ao instanciar" name=name error=e
                    @test false
                    continue
                end
                if isnothing(prob.jacobian)
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

@testset "JOS4 Jacobian domain" begin
    prob = JOS4(3)
    boundary = [0.0, 0.5, 0.5]

    @test eval_f(prob, boundary) == [0.0, 5.5]
    @test eval_jacobian_row(prob, boundary, 1) == [1.0, 0.0, 0.0]

    error = try
        eval_jacobian_row(prob, boundary, 2)
        nothing
    catch exception
        exception
    end
    @test error isa DomainError
    @test occursin("x₁ > 0", sprint(showerror, error))

    @test_throws DomainError eval_jacobian(prob, boundary)
    @test all(isfinite, eval_jacobian(prob, [eps(Float64), 0.5, 0.5]))
end

@testset "FA1 Jacobian domain" begin
    prob = FA1()
    boundary = [0.0, 0.5, 0.5]

    @test eval_f(prob, boundary) == [0.0, 1.5, 1.5]
    @test eval_jacobian_row(prob, boundary, 1) ≈ [4 / (1 - exp(-4)), 0.0, 0.0]

    for row in (2, 3)
        error = try
            eval_jacobian_row(prob, boundary, row)
            nothing
        catch exception
            exception
        end
        @test error isa DomainError
        @test occursin("x₁ > 0", sprint(showerror, error))
    end

    @test_throws DomainError eval_jacobian(prob, boundary)
    @test all(isfinite, eval_jacobian(prob, [eps(Float64), 0.5, 0.5]))
end

@testset "LE1 bounds and Jacobian domain" begin
    prob = LE1()
    origin = [0.0, 0.0]
    second_center = [0.5, 0.5]

    @test prob.bounds == (fill(-5.0, 2), fill(10.0, 2))
    @test eval_f(prob, origin) ≈ [0.0, 0.5^0.25]
    @test eval_f(prob, second_center) ≈ [0.5^0.125, 0.0]

    first_error = try
        eval_jacobian_row(prob, origin, 1)
        nothing
    catch exception
        exception
    end
    @test first_error isa DomainError
    @test occursin("(0, 0)", sprint(showerror, first_error))
    @test all(isfinite, eval_jacobian_row(prob, origin, 2))
    @test_throws DomainError eval_jacobian(prob, origin)

    second_error = try
        eval_jacobian_row(prob, second_center, 2)
        nothing
    catch exception
        exception
    end
    @test second_error isa DomainError
    @test occursin("(0.5, 0.5)", sprint(showerror, second_error))
    @test all(isfinite, eval_jacobian_row(prob, second_center, 1))
    @test_throws DomainError eval_jacobian(prob, second_center)

    @test all(isfinite, eval_jacobian(prob, [0.25, 0.25]))
end
