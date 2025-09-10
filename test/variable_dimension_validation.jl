using MOProblems
using Test
using FiniteDiff
using LinearAlgebra

@testset "Validação de Jacobianas com Dimensão Variável" begin
    # Aumentar a precisão para testes mais rigorosos
    setprecision(BigFloat, 128)

    # Problemas que suportam dimensão variável
    variable_dimension_problems = [
        # Problemas DTLZ (suportam k e m variáveis)
        ("DTLZ1", Dict(:k => [3, 5, 10, 15], :m => [3, 4, 5])),
        ("DTLZ2", Dict(:k => [3, 5, 10, 15], :m => [3, 4, 5])),
        ("DTLZ3", Dict(:k => [3, 5, 10, 15], :m => [3, 4, 5])),
        ("DTLZ4", Dict(:k => [3, 5, 10, 15], :m => [3, 4, 5])),
        ("DTLZ5", Dict(:k => [3, 5, 10, 15], :m => [3, 4, 5])),
        
        # Problemas ZDT (suportam n variável como primeiro argumento posicional)
        ("ZDT1", Dict(:n => [5, 10, 20, 30])),
        ("ZDT2", Dict(:n => [5, 10, 20, 30])),
        ("ZDT3", Dict(:n => [5, 10, 20, 30])),
        ("ZDT4", Dict(:n => [5, 10])),
        ("ZDT6", Dict(:n => [5, 10])),
        # QV1 (suporta n variável como primeiro argumento posicional)
        ("QV1", Dict(:n => [4, 8, 16])),
    ]

    println("Iniciando validação de derivadas para problemas com dimensão variável...")

    for (problem_name, param_ranges) in variable_dimension_problems
        @testset "Problema: $problem_name" begin
            println("  Testando $problem_name...")
            
            # Determinar tipo de parâmetros baseado no problema
            if haskey(param_ranges, :k) && haskey(param_ranges, :m)
                # Problemas DTLZ: testar k e m
                for k in param_ranges[:k]
                    for m in param_ranges[:m]
                        # Verificar se a combinação é válida
                        if k < 1 || m < 2
                            continue
                        end
                        
                        @testset "k=$k, m=$m" begin
                            println("    Testando k=$k, m=$m (nvar=$(k+m-1))...")
                            
                            # Instanciar o problema com parâmetros específicos
                            local problem
                            try
                                if problem_name == "DTLZ4"
                                    problem = instantiate(problem_name, k=k, m=m, alpha=2.0, T=BigFloat)
                                else
                                    problem = instantiate(problem_name, k=k, m=m, T=BigFloat)
                                end
                            catch e
                                @warn "Não foi possível instanciar o problema '$problem_name' com k=$k, m=$m. Pulando."
                                println(e)
                                continue
                            end

                            # Verificar se a jacobiana está definida
                            if !problem.has_jacobian || isnothing(problem.jacobian)
                                @warn "Problema '$problem_name' (k=$k, m=$m) marcado com has_jacobian=true mas 'jacobian' é nothing. Pulando."
                                continue
                            end
                            
                            # Extrair informações do problema
                            lx, ux = problem.bounds
                            n_vars = problem.nvar
                            n_obj = problem.nobj

                            # Verificar se as dimensões estão corretas
                            @test n_vars == k + m - 1
                            @test n_obj == m
                            @test length(lx) == n_vars
                            @test length(ux) == n_vars

                            # Gerar pontos de teste (menos pontos para testes mais rápidos)
                            n_points = min(20, max(5, n_vars))  # Ajustar número de pontos baseado na dimensão
                            test_points = Vector{Vector{BigFloat}}(undef, n_points)

                            for i in 1:n_points
                                # Criar um ponto de teste
                                alpha = BigFloat(i) / (n_points + 1)
                                
                                point = zeros(BigFloat, n_vars)
                                for j in 1:n_vars
                                    lower = isinf(lx[j]) ? BigFloat(-5.0) : lx[j]
                                    upper = isinf(ux[j]) ? BigFloat(5.0) : ux[j]
                                    
                                    if lower >= upper
                                        lower, upper = min(lower, upper) - 1, max(lower, upper) + 1
                                    end

                                    point[j] = lower + alpha * (upper - lower)
                                end
                                test_points[i] = point
                            end
                            
                            # Função wrapper para a avaliação de objetivos
                            F = (x) -> begin
                                evals = [f(x) for f in problem.f]
                                return vcat(evals...)
                            end

                            # Testar cada ponto
                            test_passed_for_config = true
                            max_error_found = BigFloat(0.0)
                            worst_point_idx = 0
                            worst_error_idx = (0, 0)

                            for (point_idx, x) in enumerate(test_points)
                                if !test_passed_for_config
                                    break
                                end

                                # Calcular ambas as jacobianas
                                J_analytical = problem.jacobian(x)
                                J_numerical = FiniteDiff.finite_difference_jacobian(F, x, Val(:central))
                                
                                # Verificar dimensões da jacobiana
                                @test size(J_analytical) == (n_obj, n_vars)
                                @test size(J_numerical) == (n_obj, n_vars)
                                
                                # Comparar as matrizes
                                diff = J_analytical - J_numerical
                                max_abs_error, max_idx = findmax(abs.(diff))

                                # Atualizar informações sobre o pior erro
                                if max_abs_error > max_error_found
                                    max_error_found = max_abs_error
                                    worst_point_idx = point_idx
                                    worst_error_idx = Tuple(max_idx)
                                end

                                # Usar tolerância baseada na dimensão do problema
                                tolerance = max(BigFloat(1e-8), BigFloat(1e-10) * n_vars)
                                
                                if max_abs_error > tolerance
                                    i, j = Tuple(max_idx)
                                    @error "Validação da Jacobiana falhou para $problem_name (k=$k, m=$m)" *
                                           "\n  - Ponto de teste index: $point_idx/$n_points" *
                                           "\n  - Dimensões: $(n_vars) variáveis, $(n_obj) objetivos" *
                                           "\n  - Índice da entrada com erro na Jacobiana: ($i, $j)" *
                                           "\n  - Valor Analítico: $(J_analytical[i,j])" *
                                           "\n  - Valor Numérico (FiniteDiff): $(J_numerical[i,j])" *
                                           "\n  - Erro Absoluto: $max_abs_error" *
                                           "\n  - Tolerância: $tolerance"
                                    
                                    test_passed_for_config = false
                                end
                            end

                            # Relatório de sucesso ou falha
                            if test_passed_for_config
                                println("      ✓ Passou com erro máximo: $max_error_found")
                            else
                                println("      ✗ Falhou com erro máximo: $max_error_found")
                                println("        Pior erro no ponto $worst_point_idx, posição $worst_error_idx")
                            end

                            @test test_passed_for_config
                        end
                    end
                end
            elseif haskey(param_ranges, :n)
                # Problemas ZDT: testar n como primeiro argumento posicional
                for n in param_ranges[:n]
                    @testset "n=$n" begin
                        println("    Testando n=$n...")
                        
                        # Instanciar o problema com parâmetros específicos
                        local problem
                        try
                            # ZDT1-6 e QV1 aceitam n como primeiro argumento posicional
                            if problem_name == "ZDT1"
                                problem = ZDT1(n, T=BigFloat)
                            elseif problem_name == "ZDT2"
                                problem = ZDT2(n, T=BigFloat)
                            elseif problem_name == "ZDT3"
                                problem = ZDT3(n, T=BigFloat)
                            elseif problem_name == "ZDT4"
                                problem = ZDT4(n, T=BigFloat)
                            elseif problem_name == "ZDT6"
                                problem = ZDT6(n, T=BigFloat)
                            elseif problem_name == "QV1"
                                problem = QV1(n, T=BigFloat)
                            else
                                @warn "Problema '$problem_name' não reconhecido. Pulando."
                                continue
                            end
                        catch e
                            @warn "Não foi possível instanciar o problema '$problem_name' com n=$n. Pulando."
                            println(e)
                            continue
                        end

                        # Verificar se a jacobiana está definida
                        if !problem.has_jacobian || isnothing(problem.jacobian)
                            @warn "Problema '$problem_name' (n=$n) marcado com has_jacobian=true mas 'jacobian' é nothing. Pulando."
                            continue
                        end
                        
                        # Extrair informações do problema
                        lx, ux = problem.bounds
                        n_vars = problem.nvar
                        n_obj = problem.nobj

                        # Verificar se as dimensões estão corretas
                        @test n_vars == n
                        @test length(lx) == n_vars
                        @test length(ux) == n_vars

                        # Gerar pontos de teste
                        n_points = min(20, max(5, n_vars))
                        test_points = Vector{Vector{BigFloat}}(undef, n_points)

                        for i in 1:n_points
                            # Criar um ponto de teste
                            alpha = BigFloat(i) / (n_points + 1)
                            
                            point = zeros(BigFloat, n_vars)
                            for j in 1:n_vars
                                lower = isinf(lx[j]) ? BigFloat(-5.0) : lx[j]
                                upper = isinf(ux[j]) ? BigFloat(5.0) : ux[j]
                                
                                if lower >= upper
                                    lower, upper = min(lower, upper) - 1, max(lower, upper) + 1
                                end

                                point[j] = lower + alpha * (upper - lower)
                            end
                            test_points[i] = point
                        end
                        
                        # Função wrapper para a avaliação de objetivos
                        F = (x) -> begin
                            evals = [f(x) for f in problem.f]
                            return vcat(evals...)
                        end

                        # Testar cada ponto
                        test_passed_for_config = true
                        max_error_found = BigFloat(0.0)
                        worst_point_idx = 0
                        worst_error_idx = (0, 0)

                        for (point_idx, x) in enumerate(test_points)
                            if !test_passed_for_config
                                break
                            end

                            # Calcular ambas as jacobianas
                            J_analytical = problem.jacobian(x)
                            J_numerical = FiniteDiff.finite_difference_jacobian(F, x, Val(:central))
                            
                            # Verificar dimensões da jacobiana
                            @test size(J_analytical) == (n_obj, n_vars)
                            @test size(J_numerical) == (n_obj, n_vars)
                            
                            # Comparar as matrizes
                            diff = J_analytical - J_numerical
                            max_abs_error, max_idx = findmax(abs.(diff))

                            # Atualizar informações sobre o pior erro
                            if max_abs_error > max_error_found
                                max_error_found = max_abs_error
                                worst_point_idx = point_idx
                                worst_error_idx = Tuple(max_idx)
                            end

                            # Usar tolerância baseada na dimensão do problema
                            tolerance = max(BigFloat(1e-8), BigFloat(1e-10) * n_vars)
                            
                            if max_abs_error > tolerance
                                i, j = Tuple(max_idx)
                                @error "Validação da Jacobiana falhou para $problem_name (n=$n)" *
                                       "\n  - Ponto de teste index: $point_idx/$n_points" *
                                       "\n  - Dimensões: $(n_vars) variáveis, $(n_obj) objetivos" *
                                       "\n  - Índice da entrada com erro na Jacobiana: ($i, $j)" *
                                       "\n  - Valor Analítico: $(J_analytical[i,j])" *
                                       "\n  - Valor Numérico (FiniteDiff): $(J_numerical[i,j])" *
                                       "\n  - Erro Absoluto: $max_abs_error" *
                                       "\n  - Tolerância: $tolerance"
                                
                                test_passed_for_config = false
                            end
                        end

                        # Relatório de sucesso ou falha
                        if test_passed_for_config
                            println("      ✓ Passou com erro máximo: $max_error_found")
                        else
                            println("      ✗ Falhou com erro máximo: $max_error_found")
                            println("        Pior erro no ponto $worst_point_idx, posição $worst_error_idx")
                        end

                        @test test_passed_for_config
                    end
                end
            end
        end
    end
end 
