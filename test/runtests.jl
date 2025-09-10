using MOProblems
using Test
using LinearAlgebra

@testset "MOProblems.jl" begin
    @testset "MHHM1 basic tests" begin
        prob = MHHM1()
        @test prob.name == "MHHM1"
        @test prob.nvar == 1
        @test prob.nobj == 3
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.5]
        fvals = eval_f(prob, x)
        @test length(fvals) == 3
        @test fvals ≈ [(0.5 - 0.8)^2, 
                       (0.5 - 0.85)^2, 
                       (0.5 - 0.9)^2]
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (3, 1)
        @test J ≈ [2.0*(0.5 - 0.8);
                   2.0*(0.5 - 0.85);
                   2.0*(0.5 - 0.9)]
    end
    
    @testset "MHHM2 basic tests" begin
        prob = MHHM2()
        @test prob.name == "MHHM2"
        @test prob.nvar == 2
        @test prob.nobj == 3
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.5, 0.5]
        fvals = eval_f(prob, x)
        @test length(fvals) == 3
        @test fvals ≈ [(0.5 - 0.8)^2 + (0.5 - 0.6)^2, 
                       (0.5 - 0.85)^2 + (0.5 - 0.7)^2, 
                       (0.5 - 0.9)^2 + (0.5 - 0.6)^2]
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (3, 2)
        @test J ≈ [2.0*(0.5 - 0.8) 2.0*(0.5 - 0.6);
                   2.0*(0.5 - 0.85) 2.0*(0.5 - 0.7);
                   2.0*(0.5 - 0.9) 2.0*(0.5 - 0.6)]
    end
    @testset "Lov1 basic tests" begin
        prob = Lov1()
        @test prob.name == "Lov1"
        @test prob.nvar == 2
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.0, 0.0]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        @test fvals ≈ [0.0, -(-0.99*9.0 - 1.03*6.25)]
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 2)
        @test J ≈ [2.1*0.0 1.96*0.0; 1.98*(-3.0) 2.06*(-2.5)]
    end
    
    @testset "Lov2 basic tests" begin
        prob = Lov2()
        @test prob.name == "Lov2"
        @test prob.nvar == 2
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.5, 0.5]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 2)
    end
    
    @testset "Lov3 basic tests" begin
        prob = Lov3()
        @test prob.name == "Lov3"
        @test prob.nvar == 2
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [1.0, 1.0]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 2)
    end
    
    @testset "Lov4 basic tests" begin
        prob = Lov4()
        @test prob.name == "Lov4"
        @test prob.nvar == 2
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [1.0, 1.0]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 2)
    end
    
    @testset "Lov5 basic tests" begin
        prob = Lov5()
        @test prob.name == "Lov5"
        @test prob.nvar == 3
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.5, 0.5, 0.5]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 3)
    end
    
    @testset "Lov6 basic tests" begin
        prob = Lov6()
        @test prob.name == "Lov6"
        @test prob.nvar == 6
        @test prob.nobj == 2
        @test prob.has_jacobian == true
        
        # Teste de avaliação da função
        x = [0.2, 0.1, 0.1, 0.1, 0.1, 0.1]
        fvals = eval_f(prob, x)
        @test length(fvals) == 2
        
        # Teste da jacobiana
        J = eval_jacobian(prob, x)
        @test size(J) == (2, 6)
    end
    
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

    @testset "Problemas MOP (Huband/Van Veldhuizen)" begin
        # MOP2
        mop2 = MOProblems.MOP2()
        @test mop2.name == "MOP2"
        @test mop2.nvar == 2
        @test mop2.nobj == 2
        @test mop2.has_bounds == true
        @test mop2.bounds == (fill(-1.0, 2), fill(1.0, 2))
        x = [0.0, 0.0]
        f = eval_f(mop2, x)
        @test length(f) == 2
        @test isapprox(f[1], 1 - exp(-1.0), atol=1e-12)
        @test f[1] ≈ f[2]
        J = eval_jacobian(mop2, x)
        @test size(J) == (2, 2)

        # MOP3
        mop3 = MOProblems.MOP3()
        @test mop3.name == "MOP3"
        @test mop3.nvar == 2
        @test mop3.nobj == 2
        @test mop3.has_bounds == true
        @test mop3.bounds == (fill(-Float64(pi), 2), fill(Float64(pi), 2))
        x = [0.3, -0.2]
        f = eval_f(mop3, x)
        @test length(f) == 2
        @test f[1] > 1.0  # pela forma 1 + somas de quadrados
        J = eval_jacobian(mop3, x)
        @test size(J) == (2, 2)

        # MOP5
        mop5 = MOProblems.MOP5()
        @test mop5.name == "MOP5"
        @test mop5.nvar == 2
        @test mop5.nobj == 3
        @test mop5.has_bounds == true
        @test mop5.bounds == (fill(-1.0, 2), fill(1.0, 2))
        x = [0.0, 0.0]
        f = eval_f(mop5, x)
        @test length(f) == 3
        @test isapprox(f[1], 0.0, atol=1e-12)
        @test isapprox(f[2], 17 + 1/27, atol=1e-12)
        @test isapprox(f[3], -0.1, atol=1e-12)
        J = eval_jacobian(mop5, x)
        @test size(J) == (3, 2)

        # MOP6
        mop6 = MOProblems.MOP6()
        @test mop6.name == "MOP6"
        @test mop6.nvar == 2
        @test mop6.nobj == 2
        @test mop6.has_bounds == true
        @test mop6.bounds == (fill(0.0, 2), fill(1.0, 2))
        x = [0.5, 0.5]
        f = eval_f(mop6, x)
        @test length(f) == 2
        @test isapprox(f[1], 0.5, atol=1e-12)
        @test isapprox(f[2], 6.0 * (1 - (1/12)^2), atol=1e-12)  # sin(8π*0.5)=0
        J = eval_jacobian(mop6, x)
        @test size(J) == (2, 2)

        # MOP7
        mop7 = MOProblems.MOP7()
        @test mop7.name == "MOP7"
        @test mop7.nvar == 2
        @test mop7.nobj == 3
        @test mop7.has_bounds == true
        @test mop7.bounds == (fill(-400.0, 2), fill(400.0, 2))
        x = [2.0, -1.0]
        f = eval_f(mop7, x)
        @test length(f) == 3
        @test isapprox(f[1], 3.0, atol=1e-12)
        @test isapprox(f[2], (2 - 1 - 3)^2/36 + (-2 - 1 + 2)^2/8 - 17, atol=1e-12)
        @test isapprox(f[3], (2 + 2*(-1) - 1)^2/175 + (-2 + 2*(-1))^2/17 - 13, atol=1e-12)
        J = eval_jacobian(mop7, x)
        @test size(J) == (3, 2)
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

    @testset "Problemas LTDZ" begin
        # Teste do problema LTDZ (Laumanns, Thiele, Deb, Zitzler, 2002)
        ltdz = MOProblems.LTDZ()
        @test ltdz.name == "LTDZ"
        @test ltdz.nvar == 3
        @test ltdz.nobj == 3
        @test ltdz.convexity == [:non_convex, :non_convex, :non_convex]
        @test ltdz.has_bounds == true
        @test ltdz.bounds == (fill(0.0, 3), fill(1.0, 3))
        @test ltdz.has_jacobian == true

        # Avaliar um ponto de referência simples
        x = [0.0, 0.0, 0.0]
        vals = eval_f(ltdz, x)
        @test length(vals) == 3
        @test vals ≈ [-2.0, -3.0, -3.0]

        # Jacobiana analítica no ponto
        J = eval_jacobian(ltdz, x)
        @test size(J) == (3, 3)
        @test J[1,1] ≈ 0.0
        @test J[1,2] ≈ 0.0
        @test J[1,3] ≈ 1.0
        @test J[2,1] ≈ 0.0
        @test J[2,2] ≈ (π/2)
        @test J[2,3] ≈ 0.0
        @test J[3,1] ≈ (π/2)
        @test J[3,2] ≈ 0.0
        @test J[3,3] ≈ 0.0
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

    @testset "Problema IM1" begin
        im1 = MOProblems.IM1()
        @test im1.name == "IM1"
        @test im1.nvar == 2
        @test im1.nobj == 2
        @test im1.has_bounds == true
        @test im1.bounds == ([1.0, 1.0], [4.0, 2.0])
        @test im1.has_jacobian == true
        @test im1.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [2.0, 1.5]
        vals = eval_f(im1, x_ref)
        @test length(vals) == 2
        @test vals[1] ≈ 2.0 * sqrt(2.0)  # 2.0 * sqrt(x₁)
        @test vals[2] ≈ 2.0 * (1.0 - 1.5) + 5.0  # x₁ * (1.0 - x₂) + 5.0

        # Jacobiana analítica no ponto
        J = eval_jacobian(im1, x_ref)
        @test size(J) == (2, 2)
        
        # Verificar valores específicos da jacobiana
        @test J[1,1] ≈ 1.0 / sqrt(2.0)  # ∂f₁/∂x₁ = 1.0 / sqrt(x₁)
        @test J[1,2] ≈ 0.0               # ∂f₁/∂x₂ = 0.0
        @test J[2,1] ≈ 1.0 - 1.5         # ∂f₂/∂x₁ = (1.0 - x₂)
        @test J[2,2] ≈ -2.0              # ∂f₂/∂x₂ = -x₁
    end

    @testset "Problema JOS1" begin
        jos1 = MOProblems.JOS1()
        @test jos1.name == "JOS1"
        @test jos1.nvar == 2
        @test jos1.nobj == 2
        @test jos1.has_bounds == true
        @test jos1.bounds == (fill(-100.0, 2), fill(100.0, 2))
        @test jos1.has_jacobian == true
        @test jos1.convexity == [:strictly_convex, :strictly_convex]

        # Avaliar ponto de referência
        x_ref = [1.0, 3.0]
        vals = eval_f(jos1, x_ref)
        @test length(vals) == 2
        @test vals[1] ≈ (1.0^2 + 3.0^2) / 2  # média dos quadrados
        @test vals[2] ≈ ((1.0 - 2.0)^2 + (3.0 - 2.0)^2) / 2  # média dos quadrados das diferenças

        # Jacobiana analítica no ponto
        J = eval_jacobian(jos1, x_ref)
        @test size(J) == (2, 2)
        
        # Verificar valores específicos da jacobiana
        @test J[1,1] ≈ 2.0 * 1.0 / 2  # ∂f₁/∂x₁ = 2.0 * x₁ / n
        @test J[1,2] ≈ 2.0 * 3.0 / 2  # ∂f₁/∂x₂ = 2.0 * x₂ / n
        @test J[2,1] ≈ 2.0 * (1.0 - 2.0) / 2  # ∂f₂/∂x₁ = 2.0 * (x₁ - 2.0) / n
        @test J[2,2] ≈ 2.0 * (3.0 - 2.0) / 2  # ∂f₂/∂x₂ = 2.0 * (x₂ - 2.0) / n
    end

    @testset "Problema JOS4" begin
        jos4 = MOProblems.JOS4()
        @test jos4.name == "JOS4"
        @test jos4.nvar == 20
        @test jos4.nobj == 2
        @test jos4.has_bounds == true
        @test jos4.bounds == (fill(0.01, 20), fill(1.0, 20))
        @test jos4.has_jacobian == true
        @test jos4.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência (primeiro elemento 0.5, resto 0.1)
        x_ref = [0.5; fill(0.1, 19)]
        vals = eval_f(jos4, x_ref)
        @test length(vals) == 2
        @test vals[1] ≈ 0.5  # f₁(x) = x₁
        
        # Calcular f₂ manualmente para verificação
        sum_x2n = sum(x_ref[2:20])
        faux = 1.0 + 9.0 * sum_x2n / 19
        t = x_ref[1] / faux
        expected_f2 = faux * (1.0 - t^0.25 - t^4.0)
        @test vals[2] ≈ expected_f2

        # Jacobiana analítica no ponto
        J = eval_jacobian(jos4, x_ref)
        @test size(J) == (2, 20)
        
        # Verificar valores específicos da jacobiana
        @test J[1,1] ≈ 1.0  # ∂f₁/∂x₁ = 1.0
        @test all(J[1,2:20] .≈ 0.0)  # ∂f₁/∂xᵢ = 0.0 para i > 1
    end

    @testset "Problema KW2" begin
        kw2 = MOProblems.KW2()
        @test kw2.name == "KW2"
        @test kw2.nvar == 2
        @test kw2.nobj == 2
        @test kw2.has_bounds == true
        @test kw2.bounds == (fill(-3.0, 2), fill(3.0, 2))
        @test kw2.has_jacobian == true
        @test kw2.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [0.0, 0.0]
        vals = eval_f(kw2, x_ref)
        @test length(vals) == 2
        
        # Calcular f₁ manualmente para verificação
        expected_f1 = -3.0 * (1.0 - 0.0)^2 * exp(-0.0^2 - (0.0 + 1.0)^2) +
                      10.0 * (0.0/5.0 - 0.0^3 - 0.0^5) * exp(-0.0^2 - 0.0^2) +
                      3.0 * exp(-(0.0 + 2.0)^2 - 0.0^2) - 0.5 * (2.0 * 0.0 + 0.0)
        @test vals[1] ≈ expected_f1
        
        # Calcular f₂ manualmente para verificação
        expected_f2 = -3.0 * (1.0 + 0.0)^2 * exp(-0.0^2 - (1.0 - 0.0)^2) +
                      10.0 * (-0.0/5.0 + 0.0^3 + 0.0^5) * exp(-0.0^2 - 0.0^2) +
                      3.0 * exp(-(2.0 - 0.0)^2 - 0.0^2)
        @test vals[2] ≈ expected_f2

        # Jacobiana analítica no ponto
        J = eval_jacobian(kw2, x_ref)
        @test size(J) == (2, 2)
    end

    @testset "Problema LE1" begin
        le1 = MOProblems.LE1()
        @test le1.name == "LE1"
        @test le1.nvar == 2
        @test le1.nobj == 2
        @test le1.has_bounds == true
        @test le1.bounds == (fill(1.0, 2), fill(10.0, 2))
        @test le1.has_jacobian == true
        @test le1.convexity == [:non_convex, :non_convex]

        # Avaliar ponto de referência
        x_ref = [2.0, 3.0]
        vals = eval_f(le1, x_ref)
        @test length(vals) == 2
        
        # Calcular f₁ manualmente para verificação
        expected_f1 = (2.0^2 + 3.0^2)^0.125
        @test vals[1] ≈ expected_f1
        
        # Calcular f₂ manualmente para verificação
        expected_f2 = ((2.0 - 0.5)^2 + (3.0 - 0.5)^2)^0.25
        @test vals[2] ≈ expected_f2

        # Jacobiana analítica no ponto
        J = eval_jacobian(le1, x_ref)
        @test size(J) == (2, 2)
        
        # Verificar valores específicos da jacobiana
        t1 = 0.25 * (2.0^2 + 3.0^2)^(-0.875)
        @test J[1,1] ≈ 2.0 * t1  # ∂f₁/∂x₁
        @test J[1,2] ≈ 3.0 * t1  # ∂f₁/∂x₂
        
        t2 = 0.5 * ((2.0 - 0.5)^2 + (3.0 - 0.5)^2)^(-0.75)
        @test J[2,1] ≈ (2.0 - 0.5) * t2  # ∂f₂/∂x₁
        @test J[2,2] ≈ (3.0 - 0.5) * t2  # ∂f₂/∂x₂
    end

    @testset "Problemas MGH" begin # Teste dos problemas MGH9, MGH16, MGH26 e MGH33 (Moré, Garbow, Hillstrom, 1981)
        mgh9 = MOProblems.MGH9()
        @test mgh9.name == "MGH9"
        @test mgh9.nvar == 3
        @test mgh9.nobj == 15
        @test mgh9.convexity == fill(:non_convex, 15)
        @test mgh9.has_bounds == true
        @test mgh9.bounds == (fill(-2.0, 3), fill(2.0, 3))
        @test mgh9.has_jacobian == true

        # Ponto de referência simples onde as expressões simplificam
        x = [0.0, 0.0, 0.0]

        # Valores alvo y(i) como no Fortran
        y = zeros(15)
        y[1] = 9.0e-4;  y[15] = 9.0e-4
        y[2] = 4.4e-3;  y[14] = 4.4e-3
        y[3] = 1.75e-2; y[13] = 1.75e-2
        y[4] = 5.4e-2;  y[12] = 5.4e-2
        y[5] = 1.295e-1; y[11] = 1.295e-1
        y[6] = 2.42e-1; y[10] = 2.42e-1
        y[7] = 3.521e-1; y[9]  = 3.521e-1
        y[8] = 3.989e-1

        # Em x = [0,0,0], f_i(x) = -y_i
        vals = eval_f(mgh9, x)
        @test length(vals) == 15
        @test vals ≈ (-y)

        # Jacobiana analítica no ponto: primeira coluna 1, demais 0
        J = eval_jacobian(mgh9, x)
        @test size(J) == (15, 3)
        @test J[:,1] ≈ ones(15)
        @test J[:,2] ≈ zeros(15)
        @test J[:,3] ≈ zeros(15)

        # MGH16 (Brown & Dennis)
        mgh16 = MOProblems.MGH16()
        @test mgh16.name == "MGH16"
        @test mgh16.nvar == 4
        @test mgh16.nobj == 5
        @test mgh16.has_bounds == true
        @test mgh16.bounds == ([-25.0, -5.0, -5.0, -1.0], [25.0, 5.0, 5.0, 1.0])
        @test mgh16.has_jacobian == true

        # Sanity evaluations for MGH16
        x = zeros(4)
        vals = eval_f(mgh16, x)
        @test length(vals) == 5

        # Check Jacobian row for i=1 at x=0
        J = eval_jacobian(mgh16, x)
        @test size(J) == (5, 4)
        t = 1.0/5.0
        @test J[1,1] ≈ -2.0 * exp(t)
        @test J[1,2] ≈ -2.0 * t * exp(t)
        @test J[1,3] ≈ -2.0 * cos(t)
        @test J[1,4] ≈ -2.0 * sin(t) * cos(t)

        # MGH26 (Trigonometric)
        mgh26 = MOProblems.MGH26()
        @test mgh26.name == "MGH26"
        @test mgh26.nvar == 4
        @test mgh26.nobj == 4
        @test mgh26.has_bounds == true
        @test mgh26.bounds == (fill(-1.0, 4), fill(1.0, 4))  # [-1,1]^4
        @test mgh26.has_jacobian == true

        # At x = 0, objectives are zero and J is zero
        x = zeros(4)
        vals = eval_f(mgh26, x)
        @test vals ≈ zeros(4)
        J = eval_jacobian(mgh26, x)
        @test J ≈ zeros(4, 4)

        # MGH33 (Linear rank-1)
        mgh33 = MOProblems.MGH33()
        @test mgh33.name == "MGH33"
        @test mgh33.nvar == 10
        @test mgh33.nobj == 10
        @test mgh33.has_bounds == true
        @test mgh33.bounds == (fill(-1.0, 10), fill(1.0, 10))
        @test mgh33.has_jacobian == true

        # At x = 0, f_i = 1 for all i; Jacobian row i is -2*i*[1,2,...,n]
        x = zeros(10)
        vals = eval_f(mgh33, x)
        @test vals ≈ ones(10)
        J = eval_jacobian(mgh33, x)
        @test size(J) == (10, 10)
        @test J[1,1] ≈ -2.0 * 1.0 * 1.0
        @test J[2,5] ≈ -2.0 * 2.0 * 5.0
        @test J[10,10] ≈ -2.0 * 10.0 * 10.0
    end

    @testset "Registro de problemas" begin
        # Verificar que alguns problemas conhecidos estão listados nos metadados
        names = MOProblems.get_problem_names()
        @test "AAS2" in names
        @test "AAS2" in names
        @test "AP1" in names
        @test "AP2" in names
        @test "AP3" in names
        @test "AP4" in names
        @test "BK1" in names
        @test "DD1" in names
        @test "DGO0" in names
        @test "DGO1" in names
        @test "DGO2" in names
        @test "DTLZ1" in names
        @test "DTLZ2" in names
        @test "DTLZ3" in names
        @test "DTLZ4" in names
        @test "DTLZ5" in names
        @test "Hil1" in names
        @test "LTDZ" in names
        @test "MGH9" in names
        @test "MGH16" in names
        @test "MGH26" in names
        @test "ZDT1" in names
        @test "ZDT2" in names
        @test "ZDT3" in names
        @test "ZDT4" in names
        @test "ZDT6" in names

        # Construir problemas diretamente via construtores para verificar acesso
        zdt1 = MOProblems.ZDT1()
        @test zdt1.nvar == 30
        ap1 = MOProblems.AP1()
        @test ap1.nobj == 3

        # Filtrar problemas por propriedades (usa apenas META e não gera warnings)
        convex_prob_names = MOProblems.filter_problems(any_convex=true)
        @test "ZDT1" in convex_prob_names

        non_convex_prob_names = MOProblems.filter_problems(all_non_convex=true)
        @test "ZDT6" in non_convex_prob_names

        strictly_convex_prob_names = MOProblems.filter_problems(any_strictly_convex=true)
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
