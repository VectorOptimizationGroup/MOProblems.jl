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
        #TODO: TODOS OS TESTES DE JACOBIANAS DEVEM SER FEITOS COM derivative_validation.jl
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

    @testset "Problemas DTLZ" begin
        # Teste do problema DTLZ1
        dtlz1 = MOProblems.DTLZ1()
        @test dtlz1.name == "DTLZ1"
        @test dtlz1.nvar == 7
        @test dtlz1.nobj == 3
        @test dtlz1.convexity == [:non_convex, :non_convex, :non_convex]
        @test dtlz1.has_bounds == true
        @test dtlz1.bounds == (zeros(7), ones(7))
        @test dtlz1.has_jacobian == true
        
        # Avaliar um ponto para DTLZ1
        x = fill(0.5, 7)
        valores = eval_f(dtlz1, x)
        @test length(valores) == 3
        @test all(valores .> 0)  # Todos os valores devem ser positivos
        
        # Verificar jacobiana de DTLZ1
        J = eval_jacobian(dtlz1, x)
        @test size(J) == (3, 7)
        
        # Testar DTLZ1 com parâmetros personalizados
        dtlz1_custom = MOProblems.DTLZ1(k=3, m=4)
        @test dtlz1_custom.name == "DTLZ1"
        @test dtlz1_custom.nvar == 6  # k + m - 1 = 3 + 4 - 1 = 6
        @test dtlz1_custom.nobj == 4
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.DTLZ1(k=0)  # k < 1
        @test_throws AssertionError MOProblems.DTLZ1(m=1)  # m < 2
        
        # Teste do problema DTLZ2
        dtlz2 = MOProblems.DTLZ2()
        @test dtlz2.name == "DTLZ2"
        @test dtlz2.nvar == 7
        @test dtlz2.nobj == 3
        @test dtlz2.convexity == [:non_convex, :non_convex, :non_convex]
        @test dtlz2.has_bounds == true
        @test dtlz2.bounds == (zeros(7), ones(7))
        @test dtlz2.has_jacobian == true
        
        # Avaliar um ponto para DTLZ2
        x = fill(0.5, 7)
        valores = eval_f(dtlz2, x)
        @test length(valores) == 3
        @test all(valores .> 0)  # Todos os valores devem ser positivos
        
        # Verificar jacobiana de DTLZ2
        J = eval_jacobian(dtlz2, x)
        @test size(J) == (3, 7)
        
        # Testar DTLZ2 com parâmetros personalizados
        dtlz2_custom = MOProblems.DTLZ2(k=3, m=4)
        @test dtlz2_custom.name == "DTLZ2"
        @test dtlz2_custom.nvar == 6  # k + m - 1 = 3 + 4 - 1 = 6
        @test dtlz2_custom.nobj == 4
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.DTLZ2(k=0)  # k < 1
        @test_throws AssertionError MOProblems.DTLZ2(m=1)  # m < 2
        
        # Teste do problema DTLZ3
        dtlz3 = MOProblems.DTLZ3()
        @test dtlz3.name == "DTLZ3"
        @test dtlz3.nvar == 7  # k + m - 1 = 5 + 3 - 1 = 7
        @test dtlz3.nobj == 3
        @test dtlz3.convexity == [:non_convex, :non_convex, :non_convex]
        @test dtlz3.has_bounds == true
        @test dtlz3.bounds == (zeros(7), ones(7))
        @test dtlz3.has_jacobian == true
        
        # Avaliar um ponto para DTLZ3
        x = fill(0.5, 7)
        valores = eval_f(dtlz3, x)
        @test length(valores) == 3
        @test all(valores .> 0)  # Todos os valores devem ser positivos
        
        # Verificar jacobiana de DTLZ3
        J = eval_jacobian(dtlz3, x)
        @test size(J) == (3, 7)
        
        # Testar DTLZ3 com parâmetros personalizados
        dtlz3_custom = MOProblems.DTLZ3(k=3, m=4)
        @test dtlz3_custom.name == "DTLZ3"
        @test dtlz3_custom.nvar == 6  # k + m - 1 = 3 + 4 - 1 = 6
        @test dtlz3_custom.nobj == 4
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.DTLZ3(k=0)  # k < 1
        @test_throws AssertionError MOProblems.DTLZ3(m=1)  # m < 2
        
        # Teste do problema DTLZ4
        dtlz4 = MOProblems.DTLZ4()
        @test dtlz4.name == "DTLZ4"
        @test dtlz4.nvar == 7  # k + m - 1 = 5 + 3 - 1 = 7
        @test dtlz4.nobj == 3
        @test dtlz4.convexity == [:non_convex, :non_convex, :non_convex]
        @test dtlz4.has_bounds == true
        @test dtlz4.bounds == (zeros(7), ones(7))
        @test dtlz4.has_jacobian == true
        
        # Avaliar um ponto para DTLZ4
        x = fill(0.5, 7)
        valores = eval_f(dtlz4, x)
        @test length(valores) == 3
        @test all(valores .> 0)  # Todos os valores devem ser positivos
        
        # Verificar jacobiana de DTLZ4
        J = eval_jacobian(dtlz4, x)
        @test size(J) == (3, 7)
        
        # Testar DTLZ4 com parâmetros personalizados
        dtlz4_custom = MOProblems.DTLZ4(k=3, m=4, alpha=1.5)
        @test dtlz4_custom.name == "DTLZ4"
        @test dtlz4_custom.nvar == 6  # k + m - 1 = 3 + 4 - 1 = 6
        @test dtlz4_custom.nobj == 4
        @test length(dtlz4_custom.convexity) == 4
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.DTLZ4(k=0)  # k < 1
        @test_throws AssertionError MOProblems.DTLZ4(m=1)  # m < 2
        @test_throws AssertionError MOProblems.DTLZ4(alpha=0)  # alpha <= 0
        
        # Teste do problema DTLZ5
        dtlz5 = MOProblems.DTLZ5()
        @test dtlz5.name == "DTLZ5"
        @test dtlz5.nvar == 9  # k + m - 1 = 5 + 5 - 1 = 9
        @test dtlz5.nobj == 5
        @test dtlz5.convexity == [:non_convex, :non_convex, :non_convex, :non_convex, :non_convex]
        @test dtlz5.has_bounds == true
        @test dtlz5.bounds == (zeros(9), ones(9))
        @test dtlz5.has_jacobian == true
        
        # Avaliar um ponto para DTLZ5
        x = fill(0.5, 9)
        valores = eval_f(dtlz5, x)
        @test length(valores) == 5
        @test all(valores .> 0)  # Todos os valores devem ser positivos
        
        # Verificar jacobiana de DTLZ5
        J = eval_jacobian(dtlz5, x)
        @test size(J) == (5, 9)
        
        # Testar DTLZ5 com parâmetros personalizados
        dtlz5_custom = MOProblems.DTLZ5(k=3, m=4)
        @test dtlz5_custom.name == "DTLZ5"
        @test dtlz5_custom.nvar == 6  # k + m - 1 = 3 + 4 - 1 = 6
        @test dtlz5_custom.nobj == 4
        @test length(dtlz5_custom.convexity) == 4
        
        # Testar validações de parâmetros
        @test_throws AssertionError MOProblems.DTLZ5(k=0)  # k < 1
        @test_throws AssertionError MOProblems.DTLZ5(m=1)  # m < 2
    end

    
    @testset "Problema FA1" begin
        fa1 = MOProblems.FA1()
        @test fa1.name == "FA1"
        @test fa1.nvar == 3
        @test fa1.nobj == 3
        @test fa1.has_bounds == true
        @test fa1.bounds == (fill(1e-2, 3), fill(1.0, 3))
        @test fa1.has_jacobian == true
        @test fa1.convexity == [:non_convex, :non_convex, :non_convex]

        # Avaliar um ponto para FA1
        x = [0.5, 0.5, 0.5]
        valores = eval_f(fa1, x)
        @test length(valores) == 3
        # Testa valores esperados (comparação direta com fórmulas)
        f1_ref = (1 - exp(-4 * x[1])) / (1 - exp(-4))
        f2_ref = (x[2] + 1) * (1 - ((1 - exp(-4 * x[1])) / (x[2] + 1))^0.5)
        f3_ref = (x[3] + 1) * (1 - ((1 - exp(-4 * x[1])) / (x[3] + 1))^0.1)
        @test valores[1] ≈ f1_ref atol=1e-12
        @test valores[2] ≈ f2_ref atol=1e-12
        @test valores[3] ≈ f3_ref atol=1e-12

        J = eval_jacobian(fa1, x)
        @test size(J) == (3, 3)
    end

    @testset "Problema Far1" begin
        far1 = MOProblems.Far1()
        @test far1.name == "Far1"
        @test far1.nvar == 2
        @test far1.nobj == 2
        @test far1.has_bounds == true
        @test far1.bounds == (fill(-1.0, 2), fill(1.0, 2))
        @test far1.has_jacobian == true
        @test far1.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [0.0, 0.0]
        vals = eval_f(far1, x_ref)
        @test length(vals) == 2

        # Jacobiana analítica no ponto
        J = eval_jacobian(far1, x_ref)
        @test size(J) == (2, 2)
    end

    @testset "Problema FDS" begin
        fds = MOProblems.FDS()
        @test fds.name == "FDS"
        @test fds.nvar == 5
        @test fds.nobj == 3
        @test fds.has_bounds == true
        @test fds.bounds == (fill(-2.0, 5), fill(2.0, 5))
        @test fds.has_jacobian == true
        @test fds.convexity == [:strictly_convex, :strictly_convex, :strictly_convex]

        # Avaliar ponto de referência
        x_ref = [1.0, 2.0, 3.0, 4.0, 5.0]
        vals = eval_f(fds, x_ref)
        @test length(vals) == 3

        # Jacobiana analítica no ponto
        J = eval_jacobian(fds, x_ref)
        @test size(J) == (3, 5)
    end

    @testset "Problema FF1" begin
        ff1 = MOProblems.FF1()
        @test ff1.name == "FF1"
        @test ff1.nvar == 2
        @test ff1.nobj == 2
        @test ff1.has_bounds == true
        @test ff1.bounds == (fill(-1.0, 2), fill(1.0, 2))
        @test ff1.has_jacobian == true
        @test ff1.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [0.0, 0.0]
        vals = eval_f(ff1, x_ref)
        @test length(vals) == 2

        # Jacobiana analítica no ponto
        J = eval_jacobian(ff1, x_ref)
        @test size(J) == (2, 2)
    end

    @testset "Problema Hil1" begin
        hil1 = MOProblems.Hil1()
        @test hil1.name == "Hil1"
        @test hil1.nvar == 2
        @test hil1.nobj == 2
        @test hil1.has_bounds == true
        @test hil1.bounds == (zeros(2), ones(2))
        @test hil1.has_jacobian == true
        @test hil1.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [0.5, 0.5]
        vals = eval_f(hil1, x_ref)
        @test length(vals) == 2

        # Jacobiana analítica no ponto
        J = eval_jacobian(hil1, x_ref)
        @test size(J) == (2, 2)
    end

    @testset "Problema IKK1" begin
        ikk1 = MOProblems.IKK1()
        @test ikk1.name == "IKK1"
        @test ikk1.nvar == 2
        @test ikk1.nobj == 3
        @test ikk1.has_bounds == true
        @test ikk1.bounds == (fill(-50.0, 2), fill(50.0, 2))
        @test ikk1.has_jacobian == true
        @test ikk1.convexity == [:non_convex, :non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [10.0, 5.0]
        vals = eval_f(ikk1, x_ref)
        @test length(vals) == 3
        @test vals[1] ≈ 100.0  # 10²
        @test vals[2] ≈ 100.0  # (10-20)²
        @test vals[3] ≈ 25.0   # 5²

        # Jacobiana analítica no ponto
        J = eval_jacobian(ikk1, x_ref)
        @test size(J) == (3, 2)
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
        MOProblems.instantiate("DTLZ1")
        MOProblems.instantiate("DTLZ2")
        MOProblems.instantiate("DTLZ3")
        MOProblems.instantiate("DTLZ4")
        MOProblems.instantiate("DTLZ5")
        MOProblems.instantiate("FA1")
        MOProblems.instantiate("Far1")
        MOProblems.instantiate("FDS")
        MOProblems.instantiate("FF1")
        MOProblems.instantiate("Hil1")
        MOProblems.instantiate("IKK1")

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

@testset "Validação de Jacobianas com Dimensão Variável" begin
    println("Incluindo testes de validação de jacobianas com dimensão variável...")
    include("variable_dimension_validation.jl")
end 