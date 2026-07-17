using Test
using LinearAlgebra
using FiniteDiff
using MOProblems
using .TestUtils

@testset "Constraint API" begin
    prob = DD1()
    x = [1 / 3, 0.0, -5 / 3, 0.0, 0.0]

    @test prob.ncon == 3
    @test isnothing(prob.bounds)
    @test META["DD1"].ncon_eq == 2
    @test META["DD1"].ncon_ineq == 1
    @test prob.lcon == (0.0, 0.0, -Inf)
    @test prob.ucon == (0.0, 0.0, 0.0)

    expected_c = [0.0, 0.0, -64 / 9]
    @test eval_c(prob, x) ≈ expected_c atol = 1e-14
    @test eval_c(prob, x, 1) ≈ expected_c[1] atol = 1e-14

    values = similar(expected_c)
    @test eval_c!(values, prob, x) === values
    @test values ≈ expected_c atol = 1e-14

    expected_J = [
        1.0  2.0  -1.0  -0.5  1.0
        4.0 -2.0   0.8   0.6  0.0
        2 / 3  0.0 -10 / 3  0.0  0.0
    ]
    @test eval_constraint_jacobian(prob, x) ≈ expected_J
    @test eval_constraint_jacobian_row(prob, x, 2) ≈ expected_J[2, :]

    J = similar(expected_J)
    @test eval_constraint_jacobian!(J, prob, x) === J
    @test J ≈ expected_J

    row = Vector{Float64}(undef, prob.nvar)
    @test eval_constraint_jacobian_row!(row, prob, x, 3) === row
    @test row ≈ expected_J[3, :]

    constraint_hessians = eval_constraint_hessian(prob, x)
    @test length(constraint_hessians) == prob.ncon
    @test constraint_hessians[1] == zeros(5, 5)
    @test constraint_hessians[2] == Diagonal([0.0, 0.0, 0.0, 0.0, 1.0])
    @test constraint_hessians[3] == 2.0 * Matrix(I, 5, 5)
    @test eval_constraint_hessian_row(prob, x, 2) == constraint_hessians[2]

    Hs = [Matrix{Float64}(undef, prob.nvar, prob.nvar) for _ in 1:prob.ncon]
    @test eval_constraint_hessian!(Hs, prob, x) === Hs
    @test Hs == constraint_hessians

    H = Matrix{Float64}(undef, prob.nvar, prob.nvar)
    @test eval_constraint_hessian_row!(H, prob, x, 3) === H
    @test H == constraint_hessians[3]

    Jfd = FiniteDiff.finite_difference_jacobian(y -> eval_c(prob, y), x, Val(:central))
    @test TestUtils.relok(expected_J, Jfd)
    for i in 1:prob.ncon
        Hfd = FiniteDiff.finite_difference_hessian(
            y -> eval_c(prob, y, i),
            x,
            Val(:hcentral),
        )
        @test isapprox(constraint_hessians[i], Hfd; atol = 1e-7, rtol = 1e-6)
    end

    for T in (Float32, Float64)
        xt = T.(x)
        @test eltype(eval_c(prob, xt)) === T
        @test eltype(eval_constraint_jacobian(prob, xt)) === T
        @test all(Ht -> eltype(Ht) === T, eval_constraint_hessian(prob, xt))
    end

    unconstrained = ZDT1()
    @test unconstrained.ncon == 0
    @test isempty(eval_c(unconstrained, fill(0.5, unconstrained.nvar)))
    @test_throws ErrorException eval_constraint_jacobian(
        unconstrained,
        fill(0.5, unconstrained.nvar),
    )
    @test_throws ErrorException eval_constraint_hessian(
        unconstrained,
        fill(0.5, unconstrained.nvar),
    )
end
