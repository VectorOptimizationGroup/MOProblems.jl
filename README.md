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

### Problemas DTLZ (Deb, Thiele, Laumanns, e Zitzler)

- **DTLZ1**: Problema escalável com fronteira de Pareto linear (7 variáveis, 3 objetivos por padrão)
- **DTLZ2**: Problema escalável com fronteira de Pareto não convexa (7 variáveis, 3 objetivos por padrão)
- **DTLZ3**: Problema escalável com função auxiliar complexa (7 variáveis, 3 objetivos por padrão)
- **DTLZ4**: Problema escalável com parâmetro alpha para controle de distribuição (7 variáveis, 3 objetivos por padrão)
- **DTLZ5**: Problema escalável com fronteira de Pareto degenerada (9 variáveis, 5 objetivos por padrão)

### Problemas FA (Farhang-Mehr & Azarm, 2002)

- **FA1**: Problema com 3 variáveis e 3 objetivos (3 variáveis, 3 objetivos)

### Problemas Far (Farina, 2002)

- **Far1**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)

### Problemas FDS (Fliege, Drummond, Svaiter, 2009)

- **FDS**: Problema com 5 variáveis e 3 objetivos (5 variáveis, 3 objetivos)

### Problemas FF (Fonseca & Fleming, 1995)

- **FF1**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)

### Problemas Hil (Hillermeier, 2001)

- **Hil1**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)

### Problemas IKK (Ikeda, Kita, Kobayashi, 2001)

- **IKK1**: Problema com 2 variáveis e 3 objetivos (2 variáveis, 3 objetivos)

### Problemas IM (Ishibuchi, Murata, 1998)

- **IM1**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)

### Problemas JOS (Jin, Olhofer, Sendhoff, 2001)

- **JOS1**: Problema com 2 variáveis e 2 objetivos estritamente convexos (2 variáveis, 2 objetivos)
- **JOS4**: Problema com 20 variáveis e 2 objetivos não convexos (20 variáveis, 2 objetivos)

### Problemas KW (Kim, de Weck, 2005)

- **KW2**: Problema com 2 variáveis e 2 objetivos não convexos (2 variáveis, 2 objetivos)

### Problemas MHHM (Mao, Hirasawa, Hu, Murata, 2000)

- **MHHM1**: Problema com 1 variável e 3 objetivos convexos (1 variável, 3 objetivos)
- **MHHM2**: Problema com 2 variáveis e 3 objetivos convexos (2 variáveis, 3 objetivos)

### Problemas LE (Lis, Eiben, 1997)

- **LE1**: Problema com 2 variáveis e 2 objetivos não convexos (2 variáveis, 2 objetivos)

### Problemas Lov (Lovison, 2011)

- **Lov1**: Quadráticas deslocadas negativas (2 variáveis, 2 objetivos)
- **Lov2**: Funções não convexas com acoplamento (2 variáveis, 2 objetivos)
- **Lov3**: Soma de quadrados vs. diferença de quadrados (2 variáveis, 2 objetivos)
- **Lov4**: Quadrática com bacias exponenciais + quadrática deslocada (2 variáveis, 2 objetivos)
- **Lov5**: Funções com exponenciais e matriz simétrica (3 variáveis, 2 objetivos)
- **Lov6**: Função linear + função oscilatória e quadrática (6 variáveis, 2 objetivos)

### Problemas LTDZ (Laumanns, Thiele, Deb, Zitzler, 2002)

- **LTDZ**: Funções trigonômicas com 3 objetivos (3 variáveis, 3 objetivos)

### Problemas AAS (Amaral, Assunção, Souza, 2025)

- **AAS1**: Gradiente Lipschitz + Hölder (2 variáveis, 2 objetivos)
- **AAS2**: Dois objetivos com gradientes Hölder (2 variáveis, 2 objetivos)

### Problemas MGH (Moré, Garbow, Hillstrom, 1981)

- **MGH9**: Resíduos Gaussianos (15 objetivos) (3 variáveis, 15 objetivos)
- **MGH16**: Brown e Dennis (5 objetivos) (4 variáveis, 5 objetivos)
- **MGH26**: Trigonométrico (4 objetivos) (4 variáveis, 4 objetivos)
- **MGH33**: Linear (posto 1) (10 objetivos) (10 variáveis, 10 objetivos)

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

|Nome  | Descrição                              |nvar|nobj|Has Jacb?|Convexidade              |
|------|----------------------------------------|----|----|---------|-------------------------|
|AP1   | Ex. 1 de Ansary & Panda (2014)         | 2  | 3  | yes     | [n-cv, cv, cv]          |
|AP2   | Ex. 2 de Ansary & Panda (2014)         | 1  | 2  | yes     | [estr cv, estr cv]      |
|AP3   | Ex. 3 de Ansary & Panda (2014)         | 2  | 2  | yes     | [n-cv, n-cv]            |
|AP4   | Ex. 4 de Ansary & Panda (2014)         | 3  | 3  | yes     | [n-cv, estr cv, estr cv]|
|BK1   | Application 1 de Binh & Korn (1996)    | 2  | 2  | yes     | [estr cv, estr cv]      |
|DD1   | A numerical ex. of Das & Dennis (1998) | 5  | 2  | yes     | [estr cv, n-cv]         |
|DGO0  | Ex. 1 de Dumitrescu et al. (2000)      | 1  | 2  | yes     | [estr cv, estr cv]      |
|DGO1  | Ex. 2 de Dumitrescu et al. (2000)      | 1  | 2  | yes     | [n-cv, n-cv]            |
|DGO2  | Ex. 3 de Dumitrescu et al. (2000)      | 1  | 2  | yes     | [estr cv, estr cv]      |
|DTLZ1 | Ex. 1 de Deb et al. (2005)             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ2 | Ex. 2 de Deb et al. (2005)             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ3 | Ex. 3 de Deb et al. (2005)             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ4 | Ex. 4 de Deb et al. (2005)             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ5 | Ex. 5 de Deb et al. (2005)             | 9  | 5  | yes     | [n-cv x5]               |
|FA1   | Ex. 1 de Farhang-Mehr & Azarm (2002)   | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|Far1  | Problema de Farina (2002)              | 2  | 2  | yes     | [n-cv, n-cv]            |
|FDS   | Prob. de Fliege et al. (2009)          | 5  | 3  | yes     | [estr cv x3] |
|FF1   | Problema de Fonseca & Fleming (1995)   | 2  | 2  | yes     | [n-cv, n-cv]            |
|Hil1  | Problema de Hillermeier (2001)         | 2  | 2  | yes     | [n-cv, n-cv]            |
|IKK1  | Problema de Ikeda et al. (2001)        | 2  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|IM1   | Problema de Ishibuchi & Murata (1998)  | 2  | 2  | yes     | [n-cv, n-cv]            |
|JOS1  | Problema de Jin et al. (2001)          | 2  | 2  | yes     | [estr cv, estr cv]      |
|JOS4  | Problema de Jin et al. (2001)          | 20 | 2  | yes     | [n-cv, n-cv]            |
|KW2   | Problema de Kim & de Weck (2005)       | 2  | 2  | yes     | [n-cv, n-cv]            |
|LE1   | Problema de Lis & Eiben (1997)         | 2  | 2  | yes     | [n-cv, n-cv]            |
|Lov1  | Lovison (2011)                         | 2  | 2  | yes     | [estr cv, estr cv]      |
|Lov2  | Lovison (2011)                         | 2  | 2  | yes     | [n-cv, n-cv]            |
|Lov3  | Lovison (2011)                         | 2  | 2  | yes     | [estr cv, n-cv]         |
|Lov4  | Lovison (2011)                         | 2  | 2  | yes     | [n-cv, estr cv]         |
|Lov5  | Lovison (2011)                         | 3  | 2  | yes     | [n-cv, n-cv]            |
|Lov6  | Lovison (2011)                         | 6  | 2  | yes     | [n-cv, n-cv]            |
|LTDZ  | Laumanns, Thiele, Deb, Zitzler (2002)  | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|AAS1  | Amaral, Assunção, Souza (2025)         | 2  | 2  | yes     | [cv, cv]                |
|AAS2  | Amaral, Assunção, Souza (2025)         | 2  | 2  | no      | [cv, cv]                |
|MGH9  | Moré, Garbow, Hillstrom (1981)         | 3  | 15 | yes     | [n-cv ×15]              |
|MGH16 | Moré, Garbow, Hillstrom (1981)         | 4  | 5  | yes     | [cv ×5]                 |
|MGH26 | Moré, Garbow, Hillstrom (1981)         | 4  | 4  | yes     | [n-cv ×4]               |
|MGH33 | Moré, Garbow, Hillstrom (1981)         | 10 | 10 | yes     | [cv ×10]                |
|MHHM1 | Simulation 1 in Mao, Hirasawa, Hu, Murata (2000)       | 1  | 3  | yes     | [cv, cv, cv]            |
|MHHM2 | Simulation 2 in Mao, Hirasawa, Hu, Murata (2000)       | 2  | 3  | yes     | [cv, cv, cv]            |
|ZDT1  | Ex. 1 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT2  | Ex. 2 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT3  | Ex. 3 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT4  | Ex. 4 de Zitzler et al. (2000)         | 10 | 2  | yes     | [cv, n-cv]              |
|ZDT6  | Ex. 6 de Zitzler et al. (2000)         | 10 | 2  | yes     | [n-cv, n-cv]            |

## Referências

- **AP Problems**: Md. A. T. Ansary, & G. Panda, "A modified Quasi-Newton method for vector optimization problem," Optimization, vol. 64, no. 11, pp. 2289–2306, 2014. DOI: 10.1080/02331934.2014.947500

- **BK Problems**: T. Binh To and U. Korn, "An evolution strategy for the multiobjective optimization," The Second International Conference on Genetic Algorithms, Brno, Czech Republic, 1996.

- **DD Problems**: I. Das and J. E. Dennis, "Normal-boundary intersection: a new method for generating the Pareto surface in nonlinear multicriteria optimization problems," SIAM Journal on Optimization, vol. 8, no. 3, pp. 631–657, 1998. DOI: 10.1137/S1052623496307510

- **DGO Problems**: D. Dumitrescu, C. Grosan, and M. Oltean, "A new evolutionary approach for multiobjective optimization," Studia Universitatis Babes-Bolyai, Informatica, vol. XLV, no. 1, pp. 51–68, 2000.

- **DTLZ Problems**: Deb, K., Thiele, L., Laumanns, M., Zitzler, E. (2005). Scalable Test Problems for Evolutionary Multiobjective Optimization. In: Abraham, A., Jain, L., Goldberg, R. (eds) Evolutionary Multiobjective Optimization. Advanced Information and Knowledge Processing. Springer, London. DOI: 10.1007/1-84628-137-7_6

- **FA Problems**: A. Farhang-Mehr and S. Azarm, "Diversity assessment of Pareto optimal solution sets: an entropy approach," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 723-728 vol.1, DOI: 10.1109/CEC.2002.1007015.

- **FAR Problems**: M. Farina, "A neural network based generalized response surface multiobjective evolutionary algorithm," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 956–961, DOI: 10.1109/CEC.2002.1007054.

- **FDS Problems**: J. Fliege, L. M. Graña Drummond, and B. F. Svaiter, "Newton's Method for Multiobjective Optimization," SIAM Journal on Optimization, vol. 20, no. 2, pp. 602-626, 2009. DOI: 10.1137/08071692X.

- **FF Problems**: C. M. Fonseca and P. J. Fleming, "An Overview of Evolutionary Algorithms in Multiobjective Optimization," Evolutionary Computation, vol. 3, no. 1, pp. 1-16, March 1995. DOI: 10.1162/evco.1995.3.1.1.

- **Hil Problems**: C. Hillermeier, "Generalized Homotopy Approach to Multiobjective Optimization," Journal of Optimization Theory and Applications, vol. 110, pp. 557–583, 2001. DOI: 10.1023/A:1017536311488.

- **IKK Problems**: K. Ikeda, H. Kita and S. Kobayashi, "Failure of Pareto-based MOEAs: does non-dominated really mean near to optimal?," Proceedings of the 2001 Congress on Evolutionary Computation (IEEE Cat. No.01TH8546), Seoul, Korea (South), 2001, pp. 957-962 vol. 2. DOI: 10.1109/CEC.2001.934293.

- **IM Problems**: H. Ishibuchi and T. Murata, "A multi-objective genetic local search algorithm and its application to flowshop scheduling," in IEEE Transactions on Systems, Man, and Cybernetics, Part C (Applications and Reviews), vol. 28, no. 3, pp. 392-403, Aug. 1998, doi: 10.1109/5326.704576.

- **JOS Problems**: Y. Jin, M. Olhofer and B. Sendhoff, "Dynamic Weighted Aggregation for evolutionary multi-objective optimization: why does it work and how?," Proceedings of the 3rd Annual Conference on Genetic and Evolutionary Computation (GECCO'01), San Francisco, California, 2001, pp. 1042-1049.

- **KW Problems**: I.Y. Kim, O.L. de Weck, "Adaptive weighted-sum method for bi-objective optimization: Pareto front generation," Structural and Multidisciplinary Optimization, vol. 29, no. 2, pp. 149-158, 2005. DOI: 10.1007/s00158-004-0465-1

- **LE Problems**: J. Lis and A. E. Eiben, "A multi-sexual genetic algorithm for multiobjective optimization," Proceedings of 1997 IEEE International Conference on Evolutionary Computation (ICEC '97), Indianapolis, IN, USA, 1997, pp. 59-64, doi: 10.1109/ICEC.1997.592269.

- **Lov Problems**: A. Lovison, "Singular Continuation: Generating Piecewise Linear Approximations to Pareto Sets via Global Analysis," SIAM Journal on Optimization, 21(2), 463–490, 2011. DOI: 10.1137/100784746

- **LTDZ Problem**: M. Laumanns, L. Thiele, K. Deb, E. Zitzler, "Combining Convergence and Diversity in Evolutionary Multiobjective Optimization," Evolutionary Computation, 10(3):263–282, 2002. DOI: 10.1162/106365602760234108

- **AAS Problems**: V. S. Amaral, P. B. Assunção, D. R. Souza, "A Derivative-Free Proximal Method with Quadratic Modeling for Composite Multiobjective Optimization in the Hölder Setting," 2025.

- **MGH Problems**: J. J. Moré, B. S. Garbow, K. E. Hillstrom, "Testing Unconstrained Optimization Software," ACM Trans. Math. Softw., 7(1):17–41, 1981. DOI: 10.1145/355934.355936

- **ZDT Problems**: E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. DOI: 10.1162/106365600568202
