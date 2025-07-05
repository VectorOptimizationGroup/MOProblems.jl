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

# Problemas específicos (apenas definição das funções, sem registro antecipado)
include("problems/zdt2000.jl")
include("problems/apn.jl")
include("problems/bk1.jl")

# Exportar tipos principais
export MOProblem

# Exportar funções da interface para avaliação de funções
export eval_f, eval_g, is_feasible, has_constraints

# Exportar funções para avaliação de jacobianas
export eval_jacobian, eval_jacobian_row

# Exportar funções do registro
export get_problems, get_problem_names, filter_problems, register_problem, instantiate

# Exportar construtores de problemas específicos
export ZDT1, ZDT2, ZDT3, ZDT4, ZDT5, ZDT6
export AP1, AP2, AP3, AP4, BK1

# Exportar funções de convexidade
export get_convexity, is_strictly_convex, is_convex
export all_strictly_convex, all_convex, any_strictly_convex, any_convex

# Exportar ferramentas de metadados
export META

# Desativar registro automático: __init__ vazio
function __init__()
    # Nenhum problema é instanciado automaticamente.
end

end # module MOProblems 