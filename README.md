# MOProblems.jl

Biblioteca Julia para definição e avaliação de problemas de otimização multiobjetivo (vetoriais).

## Instalação

```julia
import Pkg
Pkg.add(url="https://github.com/seu-usuario/MOProblems.jl.git")
```

## Características

- Conjunto de problemas benchmark implementados (ZDT, AP, BK, etc.)
- Registro central de problemas para fácil acesso
- Interface simples e consistente para avaliação de funções objetivo e restrições
- Suporte para problemas com diferentes tipos de restrições
- **Implementação de jacobianas analíticas para funções vetoriais**
- Cálculo automático de jacobianas por diferenças finitas quando a versão analítica não está disponível
- Informações de convexidade para cada função objetivo

## Exemplo de Uso

```julia
using MOProblems

# === Interface Recomendada: Construtores Diretos ===

# Criar problemas diretamente
zdt1 = ZDT1()        # ZDT1 com 30 variáveis (padrão)
zdt1_50 = ZDT1(50)   # ZDT1 com 50 variáveis
ap1 = AP1()          # Problema AP1
dgo0 = DGO0()        # Problema DGO0

# Verificar propriedades do problema
println("ZDT1 - Variáveis: ", zdt1.nvar, ", Objetivos: ", zdt1.nobj)
println("Convexidade: ", get_convexity(zdt1))

# === Consultas Estáticas (Baseadas em Metadados) ===

# Listar todos os problemas disponíveis
nomes = get_problem_names()
println("Problemas disponíveis: ", nomes)

# Filtrar problemas por propriedades
problemas_convexos = filter_problems(any_convex=true)
problemas_com_limites = filter_problems(has_bounds=true)
problemas_jacobiana = filter_problems(has_jacobian=true)

println("Problemas com objetivos convexos: ", problemas_convexos)
println("Problemas com limites: ", problemas_com_limites)
println("Problemas com jacobiana analítica: ", problemas_jacobiana)

# === Avaliação de Funções ===

# Criar um ponto aleatório
x = rand(zdt1.nvar)

# Avaliar todas as funções objetivo
valores = eval_f(zdt1, x)
println("Valores das funções objetivo: ", valores)

# Avaliar uma função objetivo específica
f1 = eval_f(zdt1, x, 1)
println("Valor da primeira função objetivo: ", f1)

# Calcular a matriz jacobiana (gradientes)
J = eval_jacobian(zdt1, x)
println("Matriz jacobiana (", size(J), "):")
display(J)

# Calcular gradiente de uma função específica
grad1 = eval_jacobian_row(zdt1, x, 1)
println("Gradiente da primeira função objetivo: ", grad1)

# Verificar viabilidade
viavel = is_feasible(zdt1, x)
println("O ponto é viável? ", viavel)

# === Interface Legacy (Compatibilidade) ===

# Ainda funciona, mas com warnings de deprecação
zdt1_legacy = get_problem("ZDT1")  # Não recomendado
```

## Problemas Disponíveis

### Problemas AP (Ansary & Panda, 2014)

- **AP1**: Exemplo 1 - Problema com 2 variáveis e 3 objetivos (2 variáveis, 3 objetivos)
- **AP2**: Exemplo 2 - Problema com 1 variável e 2 objetivos (1 variável, 2 objetivos)
- **AP3**: Exemplo 3 - Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)
- **AP4**: Exemplo 4 - Problema com 3 variáveis e 3 objetivos (3 variáveis, 3 objetivos)

### Problemas BK (To & Korn, 1996)

- **BK1**: Application 1 - Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)

### Problemas DD (Das & Dennis, 1998)

- **DD1**: Problema com 5 variáveis e 2 objetivos (5 variáveis, 2 objetivos)

### Problemas DGO (Dumitrescu, Grosan, Oltean, 2000)

- **DGO0**: Exemplo 1 do artigo original - Funções quadráticas (1 variável, 2 objetivos)
- **DGO1**: Exemplo 2 do artigo original - Funções seno com deslocamento de fase (1 variável, 2 objetivos)
- **DGO2**: Exemplo 3 do artigo original - Função quadrática e função com raiz quadrada (1 variável, 2 objetivos)

### Problemas ZDT (Zitzler, Deb, e Thiele)

- **ZDT1**: Fronteira de Pareto convexa (30 variáveis, 2 objetivos)
- **ZDT2**: Fronteira de Pareto não convexa (30 variáveis, 2 objetivos)
- **ZDT3**: Fronteira de Pareto descontínua (30 variáveis, 2 objetivos)
- **ZDT4**: Fronteira de Pareto não convexa com muitos ótimos locais (10 variáveis, 2 objetivos)
- **ZDT6**: Fronteira de Pareto não convexa e não uniforme (10 variáveis, 2 objetivos)

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

| Nome  | Descrição                          | nvar  | nobj | Jacobiana | Convexidade            |
|-------|------------------------------------|-------|------|-----------|------------------------|
| AP1   | Exemplo 1 de Ansary & Panda (2014) | 2     | 3    | ✓         | [n-conv, conv, conv]   |
| AP2   | Exemplo 2 de Ansary & Panda (2014) | 1     | 2    | ✓         | [estr conv, estr conv] |
| AP3   | Exemplo 3 de Ansary & Panda (2014) | 2     | 2    | ✓         | [n-conv, n-conv]       |
| AP4   | Exemplo 4 de Ansary & Panda (2014) | 3     | 3    | ✓         | [n-conv, estr conv, estr conv] |
| BK1   | Application 1 de To & Korn (1996)  | 2     | 2    | ✓         | [estr conv, estr conv] |
| DD1   | A numerical example of Das & Dennis (1998) | 5     | 2    | ✓         | [estr conv, n-conv]    |
| DGO0  | Exemplo 1 de Dumitrescu, Grosan, Oltean (2000) | 1     | 2    | ✓         | [estr conv, estr conv] |
| DGO1  | Exemplo 2 de Dumitrescu, Grosan, Oltean (2000) | 1     | 2    | ✓         | [n-conv, n-conv]       |
| DGO2  | Exemplo 3 de Dumitrescu, Grosan, Oltean (2000) | 1     | 2    | ✓         | [estr conv, estr conv] |
| ZDT1  | Exemplo 1 de Zitzler et al. (2000) | 30    | 2    | ✓         | [conv, n-conv]         |
| ZDT2  | Exemplo 2 de Zitzler et al. (2000) | 30    | 2    | ✓         | [conv, n-conv]         |
| ZDT3  | Exemplo 3 de Zitzler et al. (2000) | 30    | 2    | ✓         | [conv, n-conv]         |
| ZDT4  | Exemplo 4 de Zitzler et al. (2000) | 10    | 2    | ✓         | [conv, n-conv]         |
| ZDT6  | Exemplo 6 de Zitzler et al. (2000) | 10    | 2    | ✓         | [n-conv, n-conv]       |

## Referências

- **AP Problems**: Md. A. T. Ansary, & G. Panda, "A modified Quasi-Newton method for vector optimization problem," Optimization, vol. 64, no. 11, pp. 2289–2306, 2014. DOI: 10.1080/02331934.2014.947500

- **BK Problems**: T. Binh To and U. Korn, "An evolution strategy for the multiobjective optimization," The Second International Conference on Genetic Algorithms, Brno, Czech Republic, 1996.

- **DD Problems**: I. Das and J. E. Dennis, "Normal-boundary intersection: a new method for generating the Pareto surface in nonlinear multicriteria optimization problems," SIAM Journal on Optimization, vol. 8, no. 3, pp. 631–657, 1998. DOI: 10.1137/S1052623496307510

- **DGO Problems**: D. Dumitrescu, C. Grosan, and M. Oltean, "A new evolutionary approach for multiobjective optimization," Studia Universitatis Babes-Bolyai, Informatica, vol. XLV, no. 1, pp. 51–68, 2000.

- **ZDT Problems**: E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. DOI: 10.1162/106365600568202