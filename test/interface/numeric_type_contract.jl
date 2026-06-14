using Test
using MOProblems

function _interior_point(prob, ::Type{T}) where {T <: AbstractFloat}
    if prob.has_bounds
        lower, upper = prob.bounds
        x = Vector{T}(undef, prob.nvar)
        for i in 1:prob.nvar
            li = isfinite(lower[i]) ? T(lower[i]) : -one(T)
            ui = isfinite(upper[i]) ? T(upper[i]) : one(T)
            x[i] = (li + ui) / T(2)
        end
        return x
    end
    return fill(T(0.25), prob.nvar)
end

function _test_objective_and_jacobian_types(prob, ::Type{T}) where {T <: AbstractFloat}
    x = _interior_point(prob, T)

    values = MOProblems.eval_f(prob, x)
    @test eltype(values) === T
    @test length(values) == prob.nobj

    value = MOProblems.eval_f(prob, x, 1)
    @test typeof(value) === T

    J = MOProblems.eval_jacobian(prob, x)
    @test eltype(J) === T
    @test size(J) == (prob.nobj, prob.nvar)

    row = MOProblems.eval_jacobian_row(prob, x, 1)
    @test eltype(row) === T
    @test length(row) == prob.nvar
end

function _test_hessian_types(prob, ::Type{T}) where {T <: AbstractFloat}
    x = _interior_point(prob, T)

    Hs = MOProblems.eval_hessian(prob, x)
    @test length(Hs) == prob.nobj
    @test all(H -> eltype(H) === T, Hs)
    @test all(H -> size(H) == (prob.nvar, prob.nvar), Hs)

    H = MOProblems.eval_hessian_row(prob, x, 1)
    @test eltype(H) === T
    @test size(H) == (prob.nvar, prob.nvar)
end

@testset "Numeric Type Contract" begin
    for T in (Float32, Float64)
        @testset "constructor and input type agree: $(T)" begin
            _test_objective_and_jacobian_types(ZDT1(5; T = T), T)
            _test_objective_and_jacobian_types(DTLZ2(k = 3, m = 4, T = T), T)

            ap1 = AP1(T = T)
            _test_objective_and_jacobian_types(ap1, T)
            _test_hessian_types(ap1, T)
        end
    end

    @testset "input type drives output type" begin
        zdt1 = ZDT1(5; T = Float64)
        x = _interior_point(zdt1, Float32)

        @test eltype(MOProblems.eval_f(zdt1, x)) === Float32
        @test eltype(MOProblems.eval_jacobian(zdt1, x)) === Float32
        @test eltype(MOProblems.eval_jacobian_row(zdt1, x, 1)) === Float32

        ap1 = AP1(T = Float64)
        xh = _interior_point(ap1, Float32)

        @test all(H -> eltype(H) === Float32, MOProblems.eval_hessian(ap1, xh))
        @test eltype(MOProblems.eval_hessian_row(ap1, xh, 1)) === Float32
    end
end
