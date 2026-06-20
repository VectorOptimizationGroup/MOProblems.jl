using Test
using MOProblems
using .TestUtils

@testset "Variable Dimension" begin
    names = sort(MOProblems.get_problem_names())
    for name in names
        meta = MOProblems.META[name]
        if !(meta.dimension isa FixedDimension)
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


@testset "Dimension specification contracts" begin
    for constructor in (DTLZ1, DTLZ2, DTLZ3, DTLZ4, DTLZ5)
        problem = constructor(k=4, m=5)
        @test problem.nvar == 8
        @test problem.nobj == 5
        k_error = try
            constructor(k=0)
            nothing
        catch error
            error
        end
        @test k_error isa ArgumentError
        @test occursin("k must be at least 1", sprint(showerror, k_error))
        @test_throws ArgumentError constructor(m=1)
    end

    for constructor in (MGH26, Toi9)
        problem = constructor(n=6)
        @test problem.nvar == 6
        @test problem.nobj == 6
        @test_throws MethodError constructor(n=6, m=6)
    end

    @test_throws ArgumentError MGH26(n=0)
    @test_throws ArgumentError Toi9(n=1)

    for n in (2, 4, 7)
        problem = Toi10(n=n)
        @test problem.nvar == n
        @test problem.nobj == n - 1
        @test length(problem.bounds[1]) == n
        @test size(eval_jacobian(problem, zeros(n))) == (n - 1, n)
    end
    @test_throws ArgumentError Toi10(n=1)

    for constructor in (FDS, JOS1)
        problem = constructor(6)
        @test problem.nvar == 6
        @test_throws ArgumentError constructor(0)
    end
end
