using Test
using MOProblems
using .TestUtils

const _FUNCTION_COLLECTION = Union{AbstractVector, Tuple}

function _test_function_collection(functions, expected_rows)
    @test functions isa _FUNCTION_COLLECTION
    @test length(functions) == expected_rows
    @test all(f -> f isa Function, functions)
end

function _test_derivative_collection(derivative, expected_rows)
    isnothing(derivative) && return
    _test_function_collection(derivative, expected_rows)
end

function _test_problem_shape(prob)
    @test prob.nvar >= 1
    @test prob.nobj >= 1
    _test_function_collection(prob.f, prob.nobj)

    if !isnothing(prob.bounds)
        @test prob.bounds isa Tuple
        @test length(prob.bounds) == 2
        lower, upper = prob.bounds
        @test length(lower) == prob.nvar
        @test length(upper) == prob.nvar
        @test all(bound -> bound isa Real, lower)
        @test all(bound -> bound isa Real, upper)
        @test all(lower .<= upper)
    end

    _test_derivative_collection(prob.jacobian, prob.nobj)
    _test_derivative_collection(prob.hessian, prob.nobj)

    @test prob.ncon == length(prob.c)
    _test_function_collection(prob.c, prob.ncon)
    @test prob.lcon isa _FUNCTION_COLLECTION
    @test prob.ucon isa _FUNCTION_COLLECTION
    @test length(prob.lcon) == prob.ncon
    @test length(prob.ucon) == prob.ncon
    @test all(bound -> bound isa Real, prob.lcon)
    @test all(bound -> bound isa Real, prob.ucon)
    @test all(prob.lcon .<= prob.ucon)
    _test_derivative_collection(prob.constraint_jacobian, prob.ncon)
    _test_derivative_collection(prob.constraint_hessian, prob.ncon)

    x = TestUtils.sample_x(prob)
    @test length(eval_f(prob, x)) == prob.nobj
    @test length(eval_c(prob, x)) == prob.ncon

    if !isnothing(prob.jacobian)
        @test size(eval_jacobian(prob, x)) == (prob.nobj, prob.nvar)
    end
    if !isnothing(prob.hessian)
        Hs = eval_hessian(prob, x)
        @test length(Hs) == prob.nobj
        @test all(H -> size(H) == (prob.nvar, prob.nvar), Hs)
    end
    if !isnothing(prob.constraint_jacobian)
        @test size(eval_constraint_jacobian(prob, x)) == (prob.ncon, prob.nvar)
    end
    if !isnothing(prob.constraint_hessian)
        Hs = eval_constraint_hessian(prob, x)
        @test length(Hs) == prob.ncon
        @test all(H -> size(H) == (prob.nvar, prob.nvar), Hs)
    end
end

function _test_default_metadata(prob, meta)
    @test prob.name == meta.name
    @test prob.nvar == default_nvar(meta)
    @test prob.nobj == default_nobj(meta)
    @test meta.ncon_eq >= 0
    @test meta.ncon_ineq >= 0
    @test prob.ncon == meta.ncon_eq + meta.ncon_ineq
    @test count(i -> prob.lcon[i] == prob.ucon[i], 1:prob.ncon) == meta.ncon_eq
    @test count(i -> prob.lcon[i] != prob.ucon[i], 1:prob.ncon) == meta.ncon_ineq
    @test (!isnothing(prob.bounds)) == meta.has_bounds
    @test (!isnothing(prob.jacobian)) == meta.has_jacobian
    @test (!isnothing(prob.hessian)) == meta.has_hessian
    @test (!isnothing(prob.constraint_jacobian)) == meta.has_constraint_jacobian
    @test (!isnothing(prob.constraint_hessian)) == meta.has_constraint_hessian

    if prob.ncon == 0
        @test !meta.has_constraint_jacobian
        @test !meta.has_constraint_hessian
    end

    if !isnothing(meta.strict_convexity)
        @test length(meta.strict_convexity) == prob.nobj
        @test all(
            value -> value in (:strictly_convex, :not_strictly_convex),
            meta.strict_convexity,
        )
    end
end

@testset "Problem definition contracts" begin
    for name in sort(get_problem_names())
        @testset "$name default" begin
            meta = META[name]
            @test meta.dimension isa AbstractDimensionSpec
            @test default_nvar(meta) >= 1
            @test default_nobj(meta) >= 1

            prob = getfield(MOProblems, Symbol(name))()
            _test_problem_shape(prob)
            _test_default_metadata(prob, meta)
        end
    end

    for name in sort(get_problem_names())
        meta = META[name]
        meta.dimension isa FixedDimension && continue
        for n in TestUtils.dims()
            @testset "$name dimension=$n" begin
                _test_problem_shape(TestUtils.instantiate_with_dimension(name, n))
            end
        end
    end
end

@testset "Evaluation boundary checks" begin
    prob = AP1()
    x = zeros(prob.nvar)

    @test_throws DimensionMismatch eval_f(prob, zeros(prob.nvar - 1))
    @test_throws DimensionMismatch eval_f!(zeros(prob.nobj - 1), prob, x)
    @test_throws DimensionMismatch eval_jacobian!(zeros(prob.nobj, prob.nvar - 1), prob, x)
    @test_throws BoundsError eval_f(prob, x, 0)
    @test_throws BoundsError eval_f(prob, x, prob.nobj + 1)

    unconstrained = ZDT1()
    xu = fill(0.5, unconstrained.nvar)
    @test_throws BoundsError eval_c(unconstrained, xu, 1)
    @test_throws ErrorException eval_constraint_jacobian(unconstrained, xu)
    @test_throws ErrorException eval_constraint_hessian(unconstrained, xu)
end
