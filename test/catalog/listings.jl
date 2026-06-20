using Test
using MOProblems

@testset "Catalog Listings" begin
    names = MOProblems.get_problem_names()
    # Presença de alguns problemas conhecidos
    for expected in ("AP1", "DTLZ1", "MOP2", "ZDT1", "ZDT6")
        @test expected in names
    end

    meta = MOProblems.META["ZDT1"]
    @test meta isa MOProblems.ProblemMeta
    @test meta.name == "ZDT1"
    @test meta.has_hessian == false

    # Filtros devem ser determinísticos (ordenados)
    convex = MOProblems.filter_problems(any_convex=true)
    @test issorted(convex)

    # Convexity is available only for fixed dimensions.
    @test "ZDT1" ∉ convex
    nonconv = MOProblems.filter_problems(all_non_convex=true)
    @test "ZDT6" ∉ nonconv
    strict_any = MOProblems.filter_problems(any_strictly_convex=true)
    @test "AP1" in strict_any

    expected_parametric = Set(["DTLZ1", "DTLZ2", "DTLZ3", "DTLZ4", "DTLZ5"])
    expected_coupled = Set(["MGH26", "Toi9", "Toi10"])
    expected_variable = Set(["FDS", "JOS1", "QV1", "ZDT1", "ZDT2", "ZDT3", "ZDT4", "ZDT6"])
    @test Set(filter_problems(dimension_type=ParametricDimension)) == expected_parametric
    @test Set(filter_problems(dimension_type=CoupledDimension)) == expected_coupled
    @test Set(filter_problems(dimension_type=VariableNvar)) == expected_variable
    @test all(name -> META[name].dimension isa FixedDimension,
              filter_problems(dimension_type=FixedDimension))

    for (name, problem_meta) in META
        spec = problem_meta.dimension
        @test spec isa AbstractDimensionSpec
        problem = getfield(MOProblems, Symbol(name))(T=Float64)
        @test problem.nvar == default_nvar(spec)
        @test problem.nobj == default_nobj(spec)
        if spec isa FixedDimension
            @test !isnothing(problem_meta.convexity)
            @test length(problem_meta.convexity) == default_nobj(spec)
        else
            @test isnothing(problem_meta.convexity)
        end
    end

    @test dimension_parameters(META["DTLZ1"]) == (k=5, m=3)
    @test dimension_parameters(META["Toi10"]) == (n=4,)
    @test default_nvar(META["Toi10"]) == 4
    @test default_nobj(META["Toi10"]) == 3
    @test dimension_relation(META["Toi10"]).nobj == (n=1, constant=-1)

    zdt1_nvar = default_nvar(META["ZDT1"])
    by_default_nvar = filter_problems(min_vars=zdt1_nvar, max_vars=zdt1_nvar)
    @test "ZDT1" in by_default_nvar
    @test all(name -> default_nvar(META[name]) == zdt1_nvar, by_default_nvar)

    dtlz5_nobj = default_nobj(META["DTLZ5"])
    by_default_nobj = filter_problems(min_objs=dtlz5_nobj, max_objs=dtlz5_nobj)
    @test "DTLZ5" in by_default_nobj
    @test all(name -> default_nobj(META[name]) == dtlz5_nobj, by_default_nobj)

    nonfixed = Set(name for (name, problem_meta) in META
                   if !(problem_meta.dimension isa FixedDimension))
    @test nonfixed ⊆ Set(filter_problems())
    for convexity_filter in (
        (; any_strictly_convex=false),
        (; all_strictly_convex=false),
        (; any_convex=false),
        (; all_convex=false),
        (; all_non_convex=false),
    )
        @test isempty(nonfixed ∩ Set(filter_problems(; convexity_filter...)))
    end
end
