
using MOProblems
using Test
using FiniteDiff
using LinearAlgebra

@testset "Validação de Jacobianas com BigFloat" begin
    # Aumentar a precisão para algo similar à precisão quádrupla
    setprecision(BigFloat, 128)

    # Filtrar problemas que têm uma jacobiana analítica implementada
    problem_names = filter_problems(has_jacobian=true)

    println("Iniciando validação de derivadas para $(length(problem_names)) problemas usando BigFloat...")

    for problem_name in problem_names
        @testset "Problema: $problem_name" begin
            # Instanciar o problema com BigFloat
            local problem
            try
                problem = instantiate(problem_name, T=BigFloat)
            catch e
                @warn "Não foi possível instanciar o problema '$problem_name' com construtor padrão e T=BigFloat. Pulando."
                println(e)
                continue
            end

            # Pular se a jacobiana não estiver definida
            if !problem.has_jacobian || isnothing(problem.jacobian)
                @warn "Problema '$problem_name' marcado com has_jacobian=true mas 'jacobian' é nothing. Pulando."
                continue
            end
            
            # Extrair informações do problema
            lx, ux = problem.bounds
            n_vars = problem.nvar

            # Gerar 100 pontos de teste com BigFloat
            n_points = 100
            test_points = Vector{Vector{BigFloat}}(undef, n_points)

            for i in 1:n_points
                # Criar um ponto de teste combinando lx e ux
                alpha = BigFloat(i) / (n_points + 1)
                
                # Tratar limites infinitos
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
            test_passed_for_problem = true
            for (k, x) in enumerate(test_points)
                if !test_passed_for_problem
                    break
                end

                # Calcular ambas as jacobianas diretamente com BigFloat
                J_analytical = problem.jacobian(x)
                J_numerical = FiniteDiff.finite_difference_jacobian(F, x, Val(:central))
                
                # Comparar as matrizes em alta precisão
                diff = J_analytical - J_numerical
                max_abs_error, max_idx = findmax(abs.(diff))

                # Usar a tolerância definida pelo usuário
                if max_abs_error > 1e-8
                    i, j = Tuple(max_idx)
                    @error "Validação da Jacobiana falhou para o problema: $problem_name" *
                           "\n  - Ponto de teste (x): $x" *
                           "\n  - Ponto de teste index: $k/$n_points" *
                           "\n  - Índice da entrada com erro na Jacobiana: ($i, $j)" *
                           "\n  - Valor Analítico: $(J_analytical[i,j])" *
                           "\n  - Valor Numérico (FiniteDiff): $(J_numerical[i,j])" *
                           "\n  - Erro Absoluto: $max_abs_error"
                    
                    test_passed_for_problem = false
                end
            end

            @test test_passed_for_problem
        end
    end
end 