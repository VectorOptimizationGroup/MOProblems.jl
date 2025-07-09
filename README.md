# MOProblems.jl

Biblioteca Julia para definição e avaliação de problemas de otimização multiobjetivo (vetoriais).

## Instalação

```julia
import Pkg
Pkg.add(url="https://github.com/seu-usuario/MOProblems.jl.git")
```

## Características

- Conjunto de problemas benchmark implementados (ZDT, AP, etc.)
- Registro central de problemas para fácil acesso
- Interface simples e consistente para avaliação de funções objetivo e restrições
- Suporte para problemas com diferentes tipos de restrições
- **Implementação de jacobianas analíticas para funções vetoriais**
- Cálculo automático de jacobianas por diferenças finitas quando a versão analítica não está disponível
- Informações de convexidade para cada função objetivo

## Exemplo de Uso

```julia
using MOProblems

# Listar todos os problemas disponíveis
problema_names = get_problem_names()
println("Problemas disponíveis: ", problema_names)

# Obter um problema específico
problema = ZDT1()  # ou get_problem("ZDT1")

# Verificar propriedades do problema
println("Número de variáveis: ", problema.nvar)
println("Número de objetivos: ", problema.nobj)
println("Convexidade: ", get_convexity(problema))

# Criar um ponto aleatório
x = rand(problema.nvar)

# Avaliar todas as funções objetivo no ponto x
valores = eval_f(problema, x)
println("Valores das funções objetivo: ", valores)

# Avaliar uma função objetivo específica
f1 = eval_f(problema, x, 1)
println("Valor da primeira função objetivo: ", f1)

# Calcular a matriz jacobiana no ponto x
J = eval_jacobian(problema, x)
println("Matriz jacobiana:")
display(J)

# Calcular apenas uma linha da jacobiana (gradiente da i-ésima função objetivo)
grad1 = eval_jacobian_row(problema, x, 1)
println("Gradiente da primeira função objetivo: ", grad1)

# Verificar se o ponto é viável
viavel = is_feasible(problema, x)
println("O ponto é viável? ", viavel)

# Filtrar problemas por propriedades
problemas_convexos = filter_problems(any_convex=true)
println("Problemas com pelo menos uma função convexa: ", [p.name for p in problemas_convexos])
```

## Problemas Disponíveis

### Problemas ZDT (Zitzler, Deb, e Thiele)

- **ZDT1**: Fronteira de Pareto convexa (30 variáveis, 2 objetivos)
- **ZDT2**: Fronteira de Pareto não convexa (30 variáveis, 2 objetivos)
- **ZDT3**: Fronteira de Pareto descontínua (30 variáveis, 2 objetivos)
- **ZDT4**: Fronteira de Pareto não convexa com muitos ótimos locais (10 variáveis, 2 objetivos)
- **ZDT6**: Fronteira de Pareto não convexa e não uniforme (10 variáveis, 2 objetivos)

### Problemas AP (Academic Problems)

- **AP1**: Exemplo 1 de "A modified Quasi-Newton method for vector optimization problem" (2 variáveis, 3 objetivos)

## Funções de Consulta

### Avaliação de Funções

- `eval_f(problema, x)`: Avalia todas as funções objetivo no ponto x
- `eval_f(problema, x, i)`: Avalia a i-ésima função objetivo no ponto x
- `eval_g(problema, x)`: Avalia todas as restrições no ponto x (se houver)
- `is_feasible(problema, x)`: Verifica se o ponto x é viável

### Avaliação de Jacobianas

- `eval_jacobian(problema, x)`: Calcula a matriz jacobiana no ponto x
- `eval_jacobian_row(problema, x, i)`: Calcula o gradiente da i-ésima função objetivo

### Convexidade

- `get_convexity(problema)`: Retorna informações de convexidade para todas as funções objetivo
- `get_convexity(problema, i)`: Retorna a convexidade da i-ésima função objetivo
- `is_strictly_convex(problema, i)`: Verifica se a i-ésima função objetivo é estritamente convexa
- `is_convex(problema, i)`: Verifica se a i-ésima função objetivo é convexa (estrita ou não)
- `all_strictly_convex(problema)`: Verifica se todas as funções objetivo são estritamente convexas
- `all_convex(problema)`: Verifica se todas as funções objetivo são convexas
- `any_strictly_convex(problema)`: Verifica se pelo menos uma função objetivo é estritamente convexa
- `any_convex(problema)`: Verifica se pelo menos uma função objetivo é convexa

### Registro de Problemas

- `get_problem(name)`: Obtém um problema pelo nome
- `get_problems()`: Retorna todos os problemas registrados
- `get_problem_names()`: Retorna os nomes de todos os problemas registrados
- `filter_problems(...)`: Filtra problemas por propriedades específicas

## Propriedades de Convexidade

O pacote suporta informações de convexidade para cada função objetivo:

- `:strictly_convex`: A função é estritamente convexa
- `:convex`: A função é convexa, mas não necessariamente estritamente
- `:non_convex`: A função não é convexa
- `:unknown`: A convexidade da função é desconhecida

## Problemas Implementados

| Nome  | Descrição                        | nvar  | nobj | Convexidade            |
|-------|----------------------------------|-------|------|------------------------|
| ZDT1  | Fronteira de Pareto convexa      | 30    | 2    | [convexo, não-convexo] |
| ZDT2  | Fronteira de Pareto não convexa  | 30    | 2    | [convexo, não-convexo] |
| ZDT3  | Fronteira de Pareto descontínua  | 30    | 2    | [convexo, não-convexo] |
| ZDT4  | Fronteira de Pareto não convexa com muitos ótimos locais | 10 | 2 | [convexo, não-convexo] |
| ZDT6  | Fronteira de Pareto não convexa e não uniforme | 10 | 2 | [não-convexo, não-convexo] |
| AP1   | Exemplo 1 de "A modified Quasi-Newton method for vector optimization problem" | 2 | 3 | [não-convexo, estritamente convexo, estritamente convexo] |

## Referências

- E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. 