using Test
using MOProblems
using .TestUtils

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

    dtlz4_default = DTLZ4()
    dtlz4_explicit = DTLZ4(k=10, m=3, alpha=100.0)
    x = fill(0.75, dtlz4_default.nvar)
    @test eval_f(dtlz4_default, x) == eval_f(dtlz4_explicit, x)

    for constructor in (MGH26, Toi9)
        problem = constructor(n=6)
        @test problem.nvar == 6
        @test problem.nobj == 6
        @test_throws MethodError constructor(n=6, m=6)
    end

    @test_throws ArgumentError MGH26(n=0)
    @test_throws ArgumentError Toi9(n=1)

    for m in (4, 5, 8)
        problem = MGH16(m=m)
        @test problem.nvar == 4
        @test problem.nobj == m
        @test size(eval_jacobian(problem, zeros(4))) == (m, 4)
    end
    @test_throws ArgumentError MGH16(m=3)

    for (n, m) in ((2, 2), (4, 3), (10, 4), (3, 7))
        problem = MGH33(n=n, m=m)
        @test problem.nvar == n
        @test problem.nobj == m
        @test length(problem.bounds[1]) == n
        @test size(eval_jacobian(problem, zeros(n))) == (m, n)
    end
    @test_throws ArgumentError MGH33(n=1)
    @test_throws ArgumentError MGH33(m=1)

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

    jos4 = JOS4(6)
    @test jos4.nvar == 6
    @test_throws ArgumentError JOS4(1)

    @test JOS1().nvar == 50
    @test JOS1().bounds == (zeros(50), ones(50))
    @test JOS4().nvar == 50
    @test JOS4().bounds == (zeros(50), ones(50))
end
