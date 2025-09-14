using Test


    # As opções são controladas por variáveis de ambiente:

    # - MO_FAST
    #     - Valor padrão: "1"
    #     - "1" → usa dimensões rápidas (dims_fast)
    #     - "0" → usa dimensões completas (dims_full)
    #     - Exemplo: MO_FAST=0 julia --project=. -e 'using Pkg; Pkg.test()'
    # - MO_EXTENDED
    #     - Valor padrão: "0"
    #     - "1" → inclui a suíte pesada: extended/stress_suites.jl (usa dims_full)
    #     - Exemplo: MO_EXTENDED=1 MO_FAST=0 julia --project=. -e 'using Pkg; Pkg.test()'
    # - Execução rápida (padrão)
    #     - MO_FAST=1 julia --project=. -e 'using Pkg; Pkg.test()'
    # - Execução completa (sem extended)
    #     - MO_FAST=0 julia --project=. -e 'using Pkg; Pkg.test()'
    # - Execução estendida (pesada)
    #     - MO_EXTENDED=1 MO_FAST=0 julia --project=. -e 'using Pkg; Pkg.test()'

# Garantir stdlibs disponíveis mesmo com LOAD_PATH incomum
try
    @eval using Random
    @eval using LinearAlgebra
catch
    push!(Base.LOAD_PATH, "@stdlib")
    @eval using Random
    @eval using LinearAlgebra
end

using MOProblems

include(joinpath(@__DIR__, "TestUtils.jl"))

include(joinpath(@__DIR__, "smoke", "quick_smoke.jl"))
include(joinpath(@__DIR__, "interface", "interface_conformance.jl"))
include(joinpath(@__DIR__, "jacobians", "analytic_vs_fd.jl"))
include(joinpath(@__DIR__, "catalog", "listings.jl"))
include(joinpath(@__DIR__, "dimensions", "variable_dimension.jl"))
include(joinpath(@__DIR__, "problems", "auto_generated.jl"))

if get(ENV, "MO_EXTENDED", "0") == "1"
    include(joinpath(@__DIR__, "extended", "stress_suites.jl"))
end
