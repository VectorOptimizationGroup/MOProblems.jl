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

# include("problems/zdt2000.jl")
# include("problems/ap2014.jl")
# include("problems/bk1996.jl")
# include("problems/aas2025.jl")
# include("problems/dd1998.jl")
# include("problems/dgo2000.jl")
# include("problems/dtlz2005.jl")
# include("problems/fa2002.jl")
# include("problems/far2002.jl")
# include("problems/fds2009.jl")
# include("problems/ff1995.jl")
# include("problems/hil2001.jl")
# include("problems/ikk2001.jl")

# Exportar tipos principais
export MOProblem

# Exportar funções da interface para avaliação de funções
export eval_f, eval_g, is_feasible, has_constraints

# Exportar funções para avaliação de jacobianas
export eval_jacobian, eval_jacobian_row

# Exportar funções do registro
export get_problems, get_problem_names, filter_problems, register_problem, instantiate, get_problem

export ZDT1, ZDT2, ZDT3, ZDT4, ZDT6
export AP1, AP2, AP3, AP4, BK1
export AAS1, AAS2
export DD1
export DGO0, DGO1, DGO2
export DTLZ1, DTLZ2, DTLZ3, DTLZ4, DTLZ5
export FA1, Far1, FDS, FF1, Hil1, IKK1, IM1, JOS1, JOS4, KW2
export LE1, Lov1, Lov2, Lov3, Lov4, Lov5, Lov6, LTDZ, MGH9, MGH16, MGH26, MGH33

# Exportar funções de convexidade
export get_convexity, is_strictly_convex, is_convex
export all_strictly_convex, all_convex, any_strictly_convex, any_convex

# Exportar ferramentas de metadados
export META

# Sistema simplificado: sem inicialização especial necessária

end # module MOProblems
