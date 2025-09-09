module MOProblems

# Importar pacotes necessários
using LinearAlgebra

# --------------------------------------------------------------
# Metadados (deve existir antes de incluir outros arquivos que o usam)
# --------------------------------------------------------------
const META = Dict{String, Dict}()

# Tipos e estruturas de dados
include("types.jl")

# Interface para problemas multiobjetivo (precisa de `META` definido)
include("interface.jl")

# Registro de problemas (mantido para quem instanciar explicitamente)
include("registry.jl")

# Popular descrições de metadados (após possuirmos as estruturas básicas)
meta_path = joinpath(@__DIR__, "Meta")
if isdir(meta_path)
    for file in filter(f -> endswith(f, ".jl"), readdir(meta_path))
        include(joinpath("Meta", file))
        meta_sym = Symbol(replace(file, ".jl" => "_meta"))
        if isdefined(@__MODULE__, meta_sym)
            meta_dict = getfield(@__MODULE__, meta_sym)
            META[string(meta_dict[:name])] = meta_dict
        end
    end
end

# Problemas
for file in filter(f -> endswith(f, ".jl"), readdir(joinpath(@__DIR__, "problems")))
    include(joinpath("problems", file))
end

# Exportar tipos principais
export MOProblem

# Exportar funções da interface para avaliação de funções
export eval_f, eval_g, is_feasible, has_constraints

# Exportar funções para avaliação de jacobianas
export eval_jacobian, eval_jacobian_row

# Exportar funções do registro
export get_problems, get_problem_names, filter_problems, register_problem, instantiate, get_problem

export AAS1, AAS2
export AP1, AP2, AP3, AP4, BK1
export DD1
export DGO0, DGO1, DGO2
export DTLZ1, DTLZ2, DTLZ3, DTLZ4, DTLZ5
export FA1, Far1, FDS, FF1, Hil1, IKK1, IM1
export JOS1, JOS4, KW2
export LE1, Lov1, Lov2, Lov3, Lov4, Lov5, Lov6, LTDZ
export MGH9, MGH16, MGH26, MGH33
export MHHM1, MHHM2
export MLF1, MLF2
export MMR1, MMR2, MMR3, MMR4
export ZDT1, ZDT2, ZDT3, ZDT4, ZDT6

# Exportar funções de convexidade
export get_convexity, is_strictly_convex, is_convex
export all_strictly_convex, all_convex, any_strictly_convex, any_convex

# Exportar ferramentas de metadados
export META

# Sistema simplificado: sem inicialização especial necessária

end # module MOProblems
