using Test
using MOProblems

@testset "Catalog Listings" begin
    names = MOProblems.get_problem_names()
    # Presença de alguns problemas conhecidos
    for expected in ("AP1", "DTLZ1", "MOP2", "ZDT1", "ZDT6")
        @test expected in names
    end

    # Filtros devem ser determinísticos (ordenados)
    convex = MOProblems.filter_problems(any_convex=true)
    @test issorted(convex)

    # Propriedades (baseadas em META/README)
    @test "ZDT1" in convex
    nonconv = MOProblems.filter_problems(all_non_convex=true)
    @test "ZDT6" in nonconv
    strict_any = MOProblems.filter_problems(any_strictly_convex=true)
    @test "AP1" in strict_any
end

