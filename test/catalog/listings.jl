using Test
using MOProblems

@testset "Catalog Listings" begin
    names = MOProblems.get_problem_names()
    # Presença de alguns problemas conhecidos
    for expected in ("AP1", "DTLZ1", "LTDZ1", "MOP2", "ZDT1", "ZDT6")
        @test expected in names
    end
    @test "LTDZ" ∉ names

    meta = MOProblems.META["ZDT1"]
    @test meta isa MOProblems.ProblemMeta
    @test meta.name == "ZDT1"
    @test meta.has_hessian == false
    @test meta.ncon_eq == 0
    @test meta.ncon_ineq == 0
    @test hasmethod(default_nvar, Tuple{MOProblems.ProblemMeta})
    @test hasmethod(default_nobj, Tuple{MOProblems.ProblemMeta})
    @test !hasmethod(default_nvar, Tuple{FixedDimension})
    @test !hasmethod(default_nobj, Tuple{FixedDimension})

    variable_nobj_meta = MOProblems.ProblemMeta(
        dimension = VariableNobj(4, 5),
        name = "VariableNobj fixture",
    )
    @test default_nvar(variable_nobj_meta) == 4
    @test default_nobj(variable_nobj_meta) == 5

    independent_meta = MOProblems.ProblemMeta(
        dimension = IndependentDimension(10, 4),
        name = "IndependentDimension fixture",
    )
    @test default_nvar(independent_meta) == 10
    @test default_nobj(independent_meta) == 4

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
    expected_variable = Set(["FDS", "JOS1", "JOS4", "QV1", "ZDT1", "ZDT2", "ZDT3", "ZDT4", "ZDT6"])
    @test Set(filter_problems(dimension_type=ParametricDimension)) == expected_parametric
    @test Set(filter_problems(dimension_type=CoupledDimension)) == expected_coupled
    @test Set(filter_problems(dimension_type=VariableNvar)) == expected_variable
    @test filter_problems(dimension_type=VariableNobj) == ["MGH16"]
    @test filter_problems(dimension_type=IndependentDimension) == ["MGH33"]
    @test all(name -> META[name].dimension isa FixedDimension,
              filter_problems(dimension_type=FixedDimension))

    @test filter_problems(min_con_eq=1) == ["DD1"]
    @test filter_problems(min_con_ineq=1) == ["DD1"]
    @test filter_problems(has_bounds=false) ==
          ["DD1", "FF1", "Hil1", "Lov1", "Lov2", "Lov3", "Lov4", "Lov5",
           "MLF2", "PNR", "SK1", "SK2", "SP1", "SSFYY2"]
    @test filter_problems(has_constraint_jacobian=true) == ["DD1"]
    @test filter_problems(has_constraint_hessian=true) == ["DD1"]

    @test isnothing(META["AAS1"].strict_convexity)
    @test META["ZDT1"].strict_convexity == [:not_strictly_convex, :not_strictly_convex]
    @test META["DTLZ1"].strict_convexity == fill(:not_strictly_convex, 3)
    @test META["DTLZ5"].strict_convexity == fill(:not_strictly_convex, 5)
    @test META["MHHM1"].strict_convexity == fill(:strictly_convex, 3)
    @test META["MMR2"].strict_convexity == [:not_strictly_convex, :not_strictly_convex]

    @test META["DTLZ1"].dimension.default_k == 5
    @test META["DTLZ1"].dimension.default_m == 3
    @test META["DTLZ2"].dimension.default_k == 10
    @test META["DTLZ2"].dimension.default_m == 3
    @test META["DTLZ3"].dimension.default_k == 10
    @test META["DTLZ3"].dimension.default_m == 3
    @test META["DTLZ4"].dimension.default_k == 10
    @test META["DTLZ4"].dimension.default_m == 3
    @test META["DTLZ5"].dimension.default_k == 10
    @test META["DTLZ5"].dimension.default_m == 5
    @test META["Toi10"].dimension.default_nvar == 4
    @test default_nvar(META["Toi10"]) == 4
    @test default_nobj(META["Toi10"]) == 3

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
