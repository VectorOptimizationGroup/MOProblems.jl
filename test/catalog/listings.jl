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
    strict_any = MOProblems.filter_problems(any_strictly_convex=true)
    @test issorted(strict_any)
    @test "AP1" in strict_any
    @test "FDS" in strict_any
    @test "ZDT1" ∉ strict_any

    strict_none = MOProblems.filter_problems(any_strictly_convex=false)
    @test "ZDT1" in strict_none
    @test "AAS1" ∉ strict_none

    strict_all = MOProblems.filter_problems(all_strictly_convex=true)
    @test "AP2" in strict_all
    @test "AP1" ∉ strict_all

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
        problem = getfield(MOProblems, Symbol(name))()
        @test problem.nvar == default_nvar(spec)
        @test problem.nobj == default_nobj(spec)
        strict_convexity = problem_meta.strict_convexity
        if !isnothing(strict_convexity)
            @test length(strict_convexity) == default_nobj(spec)
            @test all(c -> c in (:strictly_convex, :not_strictly_convex), strict_convexity)
        end
    end

    @test isnothing(META["AAS1"].strict_convexity)
    @test META["ZDT1"].strict_convexity == [:not_strictly_convex, :not_strictly_convex]
    @test META["DTLZ1"].strict_convexity == fill(:not_strictly_convex, 3)
    @test META["DTLZ5"].strict_convexity == fill(:not_strictly_convex, 5)
    @test META["MMR2"].strict_convexity == [:not_strictly_convex, :not_strictly_convex]

    @test dimension_parameters(META["DTLZ1"]) == (k=5, m=3)
    @test dimension_parameters(META["DTLZ2"]) == (k=10, m=3)
    @test dimension_parameters(META["DTLZ3"]) == (k=10, m=3)
    @test dimension_parameters(META["DTLZ4"]) == (k=10, m=3)
    @test dimension_parameters(META["DTLZ5"]) == (k=10, m=5)
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

    without_strict_convexity = Set(name for (name, problem_meta) in META
                                   if isnothing(problem_meta.strict_convexity))
    @test without_strict_convexity ⊆ Set(filter_problems())
    for convexity_filter in (
        (; any_strictly_convex=false),
        (; all_strictly_convex=false),
    )
        @test isempty(without_strict_convexity ∩ Set(filter_problems(; convexity_filter...)))
    end
end
