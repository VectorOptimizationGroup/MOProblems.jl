using MOProblems
using Test
using LinearAlgebra

@testset "MOProblems.jl" begin
    @testset "Tipo MOProblem" begin
        # TODO: REMOVER A OPCAO DE CRIAR NOVOS PROBLEMAS
        # Funções simples para teste
        f1 = x -> x[1]
        f2 = x -> x[2]^2
        
        # Criar um problema com 2 variáveis e 2 objetivos
        prob = MOProblem(2, 2, [f1, f2]; 
                        name="Problema de Teste",
                        convexity=[:convex, :strictly_convex])
        
        @test prob.nvar == 2
        @test prob.nobj == 2
        @test prob.name == "Problema de Teste"
        @test prob.convexity == [:convex, :strictly_convex]
        
        # Testar propriedades básicas
        @test prob.ncon == 0
        @test prob.minimize == true
        @test prob.has_jacobian == false
        
        # Teste do construtor com número inválido de convexidade
        @test_throws AssertionError MOProblem(2, 2, [f1, f2]; 
                                           convexity=[:convex])
        
        # Teste do construtor com tipo de convexidade inválido
        @test_throws AssertionError MOProblem(2, 2, [f1, f2]; 
                                           convexity=[:convex, :invalid])
                                           
        # Criar problema com limites
        prob_bounds = MOProblem(
            2, 
            2, 
            [f1, f2];
            name = "Teste com Limites",
            bounds = ([0.0, 0.0], [1.0, 1.0]),
            has_bounds = true
        )
        
        @test prob_bounds.has_bounds == true
        @test prob_bounds.bounds == ([0.0, 0.0], [1.0, 1.0])
    end
    
    @testset "Avaliação de funções" begin
        # Criar problema simples
        f1 = x -> sum(x)
        f2 = x -> sum(x.^2)
        
        prob = MOProblem(3, 2, [f1, f2]; name = "Teste")
        
        # Testar avaliação das funções
        x = [1.0, 2.0, 3.0]
        
        # Avaliar todas as funções
        valores = eval_f(prob, x)
        @test length(valores) == 2
        @test valores[1] ≈ 6.0
        @test valores[2] ≈ 14.0
        
        # Avaliar funções individuais
        @test eval_f(prob, x, 1) ≈ 6.0
        @test eval_f(prob, x, 2) ≈ 14.0
    end
    
    @testset "Jacobianas por diferenças finitas" begin
        # Criar problema simples
        f1 = x -> sum(x)
        f2 = x -> sum(x.^2)
        
        prob = MOProblem(3, 2, [f1, f2]; name = "Teste")
        
        # Ponto de teste
        x = [1.0, 2.0, 3.0]
        
        # Calcular jacobiana por diferenças finitas
        J = eval_jacobian(prob, x)
        
        # Verificar dimensões
        @test size(J) == (2, 3)
        
        # Verificar valores (a jacobiana deve estar próxima dos gradientes analíticos)
        # Para f1(x) = sum(x), o gradiente é [1, 1, 1]
        # Para f2(x) = sum(x.^2), o gradiente é [2*x[1], 2*x[2], 2*x[3]] = [2, 4, 6]
        @test J[1,:] ≈ [1.0, 1.0, 1.0] atol=1e-6
        @test J[2,:] ≈ [2.0, 4.0, 6.0] atol=1e-6
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(prob, x, 1)
        grad2 = eval_jacobian_row(prob, x, 2)
        
        @test grad1 ≈ [1.0, 1.0, 1.0] atol=1e-6
        @test grad2 ≈ [2.0, 4.0, 6.0] atol=1e-6
    end
    
    @testset "Jacobianas analíticas" begin
        # Criar problema com jacobianas analíticas
        f1 = x -> sum(x)
        f2 = x -> sum(x.^2)
        
        function jac(x)
            n = length(x)
            J = zeros(2, n)
            J[1,:] .= 1.0  # Gradiente de sum(x)
            J[2,:] = 2 .* x  # Gradiente de sum(x.^2)
            return J
        end
        
        jac_rows = [
            x -> ones(length(x)),
            x -> 2 .* x
        ]
        
        prob = MOProblem(
            3, 2, [f1, f2];
            name = "Teste-Jac",
            has_jacobian = true,
            jacobian = jac,
            jacobian_by_row = jac_rows
        )
        
        # Ponto de teste
        x = [1.0, 2.0, 3.0]
        
        # Calcular jacobiana analítica
        J = eval_jacobian(prob, x)
        
        # Verificar dimensões
        @test size(J) == (2, 3)
        
        # Verificar valores
        @test J[1,:] ≈ [1.0, 1.0, 1.0]
        @test J[2,:] ≈ [2.0, 4.0, 6.0]
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(prob, x, 1)
        grad2 = eval_jacobian_row(prob, x, 2)
        
        @test grad1 ≈ [1.0, 1.0, 1.0]
        @test grad2 ≈ [2.0, 4.0, 6.0]
    end
    
    @testset "Funções de interface" begin
        # Testar funções de interface
        x_test = [1.0, 2.0]
        prob_test = MOProblem(2, 2, [x -> x[1], x -> x[2]^2]; name="Teste Interface")
        
        # Teste de eval_f
        @test eval_f(prob_test, x_test) == [1.0, 4.0]
        @test eval_f(prob_test, x_test, 1) == 1.0
        @test eval_f(prob_test, x_test, 2) == 4.0
        
        # Teste de jacobiana
        J = eval_jacobian(prob_test, x_test)
        @test size(J) == (2, 2)
        @test J ≈ [1.0 0.0; 0.0 4.0]
        
        # Teste de jacobiana por linha
        @test eval_jacobian_row(prob_test, x_test, 1) ≈ [1.0, 0.0]
        @test eval_jacobian_row(prob_test, x_test, 2) ≈ [0.0, 4.0]
    end
    
    @testset "Funções de convexidade" begin
        # Funções simples para teste
        f1 = x -> x[1]
        f2 = x -> x[2]^2
        
        # Criar um problema com 2 variáveis e 2 objetivos
        prob = MOProblem(2, 2, [f1, f2]; 
                        name="Problema de Teste",
                        convexity=[:convex, :strictly_convex])
        
        # Teste de get_convexity
        @test get_convexity(prob) == [:convex, :strictly_convex]
        @test get_convexity(prob, 1) == :convex
        @test get_convexity(prob, 2) == :strictly_convex
        @test_throws AssertionError get_convexity(prob, 3)
        
        # Teste de is_strictly_convex
        @test !is_strictly_convex(prob, 1)
        @test is_strictly_convex(prob, 2)
        @test_throws AssertionError is_strictly_convex(prob, 3)
        
        # Teste de is_convex
        @test is_convex(prob, 1)
        @test is_convex(prob, 2)
        @test_throws AssertionError is_convex(prob, 3)
        
        # Teste de all_strictly_convex
        @test !all_strictly_convex(prob)
        
        # Teste de all_convex
        @test all_convex(prob)
        
        # Teste de any_strictly_convex
        @test any_strictly_convex(prob)
        
        # Teste de any_convex
        @test any_convex(prob)
        
        # Criar outro problema com objetivos não convexos
        prob2 = MOProblem(2, 2, [f1, f2]; 
                         name="Problema de Teste 2",
                         convexity=[:non_convex, :non_convex])
        
        # Testar funções com problema não convexo
        @test !is_convex(prob2, 1)
        @test !is_convex(prob2, 2)
        @test !all_convex(prob2)
        @test !any_convex(prob2)
    end

    @testset "Problemas ZDT" begin
        # Teste do problema ZDT1
        zdt1 = MOProblems.ZDT1()
        @test zdt1.name == "ZDT1"
        @test zdt1.nvar == 30
        @test zdt1.nobj == 2
        @test zdt1.convexity == [:convex, :non_convex]
        
        # Teste do problema ZDT2
        zdt2 = MOProblems.ZDT2()
        @test zdt2.name == "ZDT2"
        @test zdt2.nvar == 30
        @test zdt2.nobj == 2
        @test zdt2.convexity == [:convex, :non_convex]
        
        # Teste do problema ZDT3
        zdt3 = MOProblems.ZDT3()
        @test zdt3.name == "ZDT3"
        @test zdt3.nvar == 30
        @test zdt3.nobj == 2
        @test zdt3.convexity == [:convex, :non_convex]
        
        # Teste do problema ZDT4
        zdt4 = MOProblems.ZDT4()
        @test zdt4.name == "ZDT4"
        @test zdt4.nvar == 10
        @test zdt4.nobj == 2
        @test zdt4.convexity == [:convex, :non_convex]
        
        # Teste do problema ZDT6
        zdt6 = MOProblems.ZDT6()
        @test zdt6.name == "ZDT6"
        @test zdt6.nvar == 10
        @test zdt6.nobj == 2
        @test zdt6.convexity == [:non_convex, :non_convex]
        
        # Avaliar um ponto para ZDT1
        x = fill(0.5, 30)
        valores = eval_f(zdt1, x)
        @test length(valores) == 2
        @test valores[1] ≈ 0.5
        
        # Verificar jacobiana de ZDT1
        J = eval_jacobian(zdt1, x)
        @test size(J) == (2, 30)
        @test J[1,1] ≈ 1.0  # Gradiente de f1
        @test all(J[1,2:end] .≈ 0.0)
    end

    @testset "Problemas AP" begin
        # Teste do problema AP1
        ap1 = MOProblems.AP1()
        @test ap1.name == "AP1"
        @test ap1.nvar == 2
        @test ap1.nobj == 3
        @test ap1.convexity == [:non_convex, :strictly_convex, :strictly_convex]
        @test ap1.has_bounds == true
        @test ap1.bounds == (fill(-10.0, 2), fill(10.0, 2))
        
        # Avaliar um ponto para AP1
        x = [1.0, 2.0]
        valores = eval_f(ap1, x)
        @test length(valores) == 3
        @test valores[1] ≈ 0.25 * ((1.0 - 1.0)^4 + 2.0 * (2.0 - 2.0)^4)
        @test valores[2] ≈ exp((1.0 + 2.0)/2.0) + 1.0^2 + 2.0^2
        @test valores[3] ≈ (1.0/6.0) * (exp(-1.0) + 2.0 * exp(-2.0))
        
        # Verificar jacobiana de AP1
        J = eval_jacobian(ap1, x)
        @test size(J) == (3, 2)
        
        # Verificar gradiente da primeira função objetivo
        @test J[1,1] ≈ (1.0 - 1.0)^3
        @test J[1,2] ≈ 2.0 * (2.0 - 2.0)^3
        
        # Verificar gradiente da segunda função objetivo
        @test J[2,1] ≈ 0.5 * exp((1.0 + 2.0)/2.0) + 2.0 * 1.0
        @test J[2,2] ≈ 0.5 * exp((1.0 + 2.0)/2.0) + 2.0 * 2.0
        
        # Verificar gradiente da terceira função objetivo
        @test J[3,1] ≈ -(1.0/6.0) * exp(-1.0)
        @test J[3,2] ≈ -(1.0/3.0) * exp(-2.0)
    end

    @testset "Problemas DGO" begin
        # Teste do problema DGO0
        dgo0 = MOProblems.DGO0()
        @test dgo0.name == "DGO0"
        @test dgo0.nvar == 1
        @test dgo0.nobj == 2
        @test dgo0.convexity == [:strictly_convex, :strictly_convex]
        @test dgo0.has_bounds == true
        @test dgo0.bounds == ([-4.0], [6.0])
        
        # Avaliar um ponto para DGO0
        x = [1.0]
        valores = eval_f(dgo0, x)
        @test length(valores) == 2
        @test valores[1] ≈ 1.0  # 1²
        @test valores[2] ≈ (1.0 - 2.0)^2  # (1-2)² = 1
        
        # Verificar jacobiana de DGO0
        J = eval_jacobian(dgo0, x)
        @test size(J) == (2, 1)
        @test J[1,1] ≈ 2.0  # Gradiente de f1: 2*1
        @test J[2,1] ≈ -2.0  # Gradiente de f2: 2*(1-2) = -2
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(dgo0, x, 1)
        grad2 = eval_jacobian_row(dgo0, x, 2)
        @test grad1 ≈ [2.0]
        @test grad2 ≈ [-2.0]
        
        # Teste do problema DGO1
        dgo1 = MOProblems.DGO1()
        @test dgo1.name == "DGO1"
        @test dgo1.nvar == 1
        @test dgo1.nobj == 2
        @test dgo1.convexity == [:non_convex, :non_convex]
        @test dgo1.has_bounds == true
        @test dgo1.bounds == ([-10.0], [13.0])
        
        # Avaliar um ponto para DGO1
        x = [0.5]
        valores = eval_f(dgo1, x)
        @test length(valores) == 2
        @test valores[1] ≈ sin(0.5)
        @test valores[2] ≈ sin(0.5 + 0.7)
        
        # Verificar jacobiana de DGO1
        J = eval_jacobian(dgo1, x)
        @test size(J) == (2, 1)
        @test J[1,1] ≈ cos(0.5)  # Gradiente de f1
        @test J[2,1] ≈ cos(0.5 + 0.7)  # Gradiente de f2
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(dgo1, x, 1)
        grad2 = eval_jacobian_row(dgo1, x, 2)
        @test grad1 ≈ [cos(0.5)]
        @test grad2 ≈ [cos(0.5 + 0.7)]
        
        # Teste do problema DGO2
        dgo2 = MOProblems.DGO2()
        @test dgo2.name == "DGO2"
        @test dgo2.nvar == 1
        @test dgo2.nobj == 2
        @test dgo2.convexity == [:strictly_convex, :strictly_convex]
        @test dgo2.has_bounds == true
        @test dgo2.bounds == ([-9.0], [9.0])
        
        # Avaliar um ponto para DGO2
        x = [2.0]
        valores = eval_f(dgo2, x)
        @test length(valores) == 2
        @test valores[1] ≈ 4.0  # 2²
        @test valores[2] ≈ 9.0 - sqrt(81.0 - 4.0)  # 9 - √(81 - 2²)
        
        # Verificar jacobiana de DGO2
        J = eval_jacobian(dgo2, x)
        @test size(J) == (2, 1)
        @test J[1,1] ≈ 4.0  # Gradiente de f1: 2*2
        @test J[2,1] ≈ 2.0 / sqrt(81.0 - 4.0)  # Gradiente de f2: 2/√(81-4)
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(dgo2, x, 1)
        grad2 = eval_jacobian_row(dgo2, x, 2)
        @test grad1 ≈ [4.0]
        @test grad2 ≈ [2.0 / sqrt(81.0 - 4.0)]
    end

    @testset "Problema DD1" begin
        # Teste do problema DD1
        dd1 = MOProblems.DD1()
        @test dd1.name == "DD1"
        @test dd1.nvar == 5
        @test dd1.nobj == 2
        @test dd1.convexity == [:strictly_convex, :non_convex]
        @test dd1.has_bounds == true
        @test dd1.bounds == (fill(-20.0, 5), fill(20.0, 5))
        
        # Avaliar um ponto para DD1
        x = [1.0, 2.0, 3.0, 4.0, 5.0]
        valores = eval_f(dd1, x)
        @test length(valores) == 2
        @test valores[1] ≈ 1.0^2 + 2.0^2 + 3.0^2 + 4.0^2 + 5.0^2  # 55
        @test valores[2] ≈ 3.0*1.0 + 2.0*2.0 - 3.0/3.0 + 0.01*(4.0-5.0)^3  # 3 + 4 - 1 - 0.01 = 5.99
        
        # Verificar jacobiana de DD1
        J = eval_jacobian(dd1, x)
        @test size(J) == (2, 5)
        @test J[1,:] ≈ [2.0, 4.0, 6.0, 8.0, 10.0]  # Gradiente de f1: 2x
        @test J[2,1] ≈ 3.0  # Gradiente de f2: primeira componente
        @test J[2,2] ≈ 2.0  # Gradiente de f2: segunda componente
        @test J[2,3] ≈ -1.0/3.0  # Gradiente de f2: terceira componente
        @test J[2,4] ≈ 0.03 * (4.0 - 5.0)^2  # Gradiente de f2: quarta componente
        @test J[2,5] ≈ -0.03 * (4.0 - 5.0)^2  # Gradiente de f2: quinta componente
        
        # Testar gradiente de uma função específica
        grad1 = eval_jacobian_row(dd1, x, 1)
        grad2 = eval_jacobian_row(dd1, x, 2)
        @test grad1 ≈ [2.0, 4.0, 6.0, 8.0, 10.0]
        @test grad2 ≈ [3.0, 2.0, -1.0/3.0, 0.03*(4.0-5.0)^2, -0.03*(4.0-5.0)^2]
    end

    @testset "Problemas AAS" begin
        # Teste do problema AAS1
        aas1 = MOProblems.AAS1()
        @test aas1.name == "AAS1"
        @test aas1.nvar == 2
        @test aas1.nobj == 2
        @test aas1.convexity == [:convex, :convex]
        @test aas1.has_bounds == true
        @test aas1.bounds == (fill(-2.0, 2), fill(2.0, 2))
        @test aas1.has_jacobian == true
        
        # Avaliar um ponto para AAS1
        x = [1.0, 2.0]
        valores = eval_f(aas1, x)
        @test length(valores) == 2
        
        # Verificar jacobiana de AAS1
        J = eval_jacobian(aas1, x)
        @test size(J) == (2, 2)
        
        # Teste do problema AAS2
        aas2 = MOProblems.AAS2()
        @test aas2.name == "AAS2"
        @test aas2.nvar == 2
        @test aas2.nobj == 2
        @test aas2.convexity == [:convex, :convex]
        @test aas2.has_bounds == true
        @test aas2.bounds == (fill(-5.0, 2), fill(5.0, 2))
        @test aas2.has_jacobian == false
        
        # Avaliar um ponto para AAS2
        x = [1.0, 2.0]
        valores = eval_f(aas2, x)
        @test length(valores) == 2
        
        # Testar AAS2 com parâmetros personalizados
        aas2_custom = MOProblems.AAS2(p1=1.5, λ1=2.0, p2=1.8, λ2=1.5)
        @test aas2_custom.name == "AAS2"
        @test aas2_custom.nvar == 2
        @test aas2_custom.nobj == 2
        
        # Verificar que os valores são diferentes com parâmetros diferentes
        valores_default = eval_f(aas2, x)
        valores_custom = eval_f(aas2_custom, x)
        @test valores_default != valores_custom
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.AAS2(p1=0.5)  # p1 < 1
        @test_throws AssertionError MOProblems.AAS2(p1=2.5)  # p1 > 2
        @test_throws AssertionError MOProblems.AAS2(λ1=-1.0)  # λ1 < 0
        @test_throws AssertionError MOProblems.AAS2(Φ1=[1.0 2.0 3.0; 4.0 5.0 6.0])  # matriz 2x3
        @test_throws AssertionError MOProblems.AAS2(c1=[1.0])  # vetor de dimensão 1
    end

    @testset "Registro de problemas" begin
        # Instanciar alguns problemas para garantir que eles estejam no registro
        # antes de executar os testes de registro.
        MOProblems.instantiate("ZDT1")
        MOProblems.instantiate("ZDT2")
        MOProblems.instantiate("ZDT3")
        MOProblems.instantiate("ZDT4")
        MOProblems.instantiate("ZDT6")
        MOProblems.instantiate("AP1")
        MOProblems.instantiate("AP2")
        MOProblems.instantiate("AP3")
        MOProblems.instantiate("AP4")
        MOProblems.instantiate("BK1")
        MOProblems.instantiate("DD1")
        MOProblems.instantiate("DGO0")
        MOProblems.instantiate("DGO1")
        MOProblems.instantiate("DGO2")
        MOProblems.instantiate("AAS1")
        MOProblems.instantiate("AAS2")

        # Obter todos os problemas registrados
        problems = MOProblems.get_problems()
        @test length(problems) >= 6
        
        # Obter problema por nome
        zdt1 = MOProblems.get_problems("ZDT1")
        @test zdt1.name == "ZDT1"
        @test zdt1.convexity == [:convex, :non_convex]
        
        # Obter problema AP1 por nome
        ap1 = MOProblems.get_problems("AP1")
        @test ap1.name == "AP1"
        @test ap1.convexity == [:non_convex, :strictly_convex, :strictly_convex]
        
        # Filtrar problemas por propriedades
        convex_prob_names = MOProblems.filter_problems(any_convex=true)
        @test !isempty(convex_prob_names)
        @test "ZDT1" in convex_prob_names
        
        non_convex_prob_names = MOProblems.filter_problems(all_non_convex=true)
        @test !isempty(non_convex_prob_names)
        @test "ZDT6" in non_convex_prob_names
        
        # Filtrar problemas com objetivos estritamente convexos
        strictly_convex_prob_names = MOProblems.filter_problems(any_strictly_convex=true)
        @test !isempty(strictly_convex_prob_names)
        @test "AP1" in strictly_convex_prob_names
    end
end

@testset "Validação de Derivadas com FiniteDiff" begin
    println("Incluindo testes de validação de derivadas...")
    include("derivative_validation.jl")
end 