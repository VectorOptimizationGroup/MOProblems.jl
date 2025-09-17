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

### Problemas AAS (Amaral, Assunção, Souza, 2025)

- **AAS1**: Gradiente Lipschitz + Hölder (2 variáveis, 2 objetivos)
- **AAS2**: Dois objetivos com gradientes Hölder (2 variáveis, 2 objetivos)

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

### Problemas MGH (Moré, Garbow, Hillstrom, 1981)

- **MGH9**: Resíduos Gaussianos (15 objetivos) (3 variáveis, 15 objetivos)
- **MGH16**: Brown e Dennis (5 objetivos) (4 variáveis, 5 objetivos)
- **MGH26**: Trigonométrico (4 objetivos) (4 variáveis, 4 objetivos)
- **MGH33**: Linear (posto 1) (10 objetivos) (10 variáveis, 10 objetivos)

### Problemas MHHM (Mao, Hirasawa, Hu, Murata, 2000)

- **MHHM1**: Problema com 1 variável e 3 objetivos convexos (1 variável, 3 objetivos)
- **MHHM2**: Problema com 2 variáveis e 3 objetivos convexos (2 variáveis, 3 objetivos)

### Problemas MLF (Molyneaux, Favrat, Leyland, 2001)

- **MLF1**: Oscilatórias em 1 variável (1 variável, 2 objetivos)
- **MLF2**: Duas funções quarticas acopladas (2 variáveis, 2 objetivos)

### Problemas MMR (Miglierina, Molho, Recchioni, 2008)

- **MMR1**: f₁(x)=x₁; f₂(x) com termos gaussianos em x₂ e divisão por x₁ (2 variáveis, 2 objetivos)
- **MMR2**: f₁(x)=x₁; f₂(x) com parâmetro a=1+10x₂ e termos sinusoidais (2 variáveis, 2 objetivos)
- **MMR3**: f₁(x)=x₁³; f₂(x)=(x₂−x₁)³ (2 variáveis, 2 objetivos)
- **MMR4**: f₁(x)=x₁−2x₂−x₃−36/(2x₁+x₂+2x₃+1); f₂(x)=−3x₁+x₂−x₃ (3 variáveis, 2 objetivos)

### Problemas MOP (Van Veldhuizen; ver Huband et al., 2006)

Baseados no conjunto MOP1–MOP7 empregado por Van Veldhuizen (ver a revisão de Huband et al., 2006). Nesta biblioteca, estão implementados:

- **MOP2**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)
- **MOP3**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)
- **MOP5**: Problema com 2 variáveis e 3 objetivos (2 variáveis, 3 objetivos)
- **MOP6**: Problema com 2 variáveis e 2 objetivos (2 variáveis, 2 objetivos)
- **MOP7**: Problema com 2 variáveis e 3 objetivos (2 variáveis, 3 objetivos)

### Problemas PNR (Preuss, Naujoks, Rudolph, 2006)

- **PNR**: Função polinomial biobjetivo com não convexidade (2 variáveis, 2 objetivos)

### Problemas QV (Quagliarella & Vicini, 1998)

- **QV1**: Agregações tipo Rastrigin com raiz de ordem 4 (n variáveis, 2 objetivos; bounds padrão [-5.12, 5.12])

### Problemas SD (Stadler & Dauer, 1992)

- **SD**: Combinação linear e termos recíprocos com bounds positivos (4 variáveis, 2 objetivos)

### Problemas SK (Socha & Kisiel-Dorohinicki, 2002)

- **SK1**: Polinômios quarticos univariados (1 variável, 2 objetivos; bounds [-100, 100])
- **SK2**: Soma de quadráticos e função seno racionalizada (4 variáveis, 2 objetivos; bounds [-10, 10]^4)

### Problemas SLCDT (Schütze, Laumanns, Coello, Dellnitz, Talbi, 2008)

- **SLCDT1**: Funções com raízes quadradas, termos lineares e exponenciais (2 variáveis, 2 objetivos)
- **SLCDT2**: Polinomiais em alta dimensão com padrões alternados (10 variáveis, 3 objetivos)

### Problemas SP (Sefrioui & Perlaux, 2000)

- **SP1**: Duas quadráticas acopladas estritamente convexas; bounds [-100, 100]^2 (2 variáveis, 2 objetivos)

### Problemas SSFYY (Shim, Suh, Furukawa, Yagawa, Yoshimura, 2002)

- **SSFYY2**: 1 variável, 2 objetivos; bounds [-100, 100]
  - f₁(x) = 10 + x² − 10 cos(πx/2) [não convexa]
  - f₂(x) = (x − 4)² [estritamente convexa]
  - Jacobiana analítica implementada: ∇f₁ = [2x + 5π sin(πx/2)], ∇f₂ = [2(x − 4)]

### Problemas TKLY (Tan, Khor, Lee, Yang, 2003)

- **TKLY1**: Função linear versus produto de termos gaussianos / racional (4 variáveis, 2 objetivos; bounds [0.1, 1] × [0, 1]^3)

### Problemas Toi (Toint, 1983)

- **Toi4**: Quadráticos desacoplados com constantes (4 variáveis, 2 objetivos; bounds [-2, 5]^4)
- **Toi8**: Cadeia tridiagonal com dependência local (3 variáveis, 3 objetivos; bounds [-1, 1]^3)
- **Toi9**: Versão deslocada da cadeia tridiagonal (4 variáveis, 4 objetivos; bounds [-1, 1]^4)
- **Toi10**: Sistema tipo Rosenbrock acoplado (4 variáveis, 3 objetivos; bounds [-2, 2]^4)

### Problemas VU (Valenzuela-Rendón & Uresti-Charre, 1997)

- **VU1**: Função racional vs. quadrática anisotrópica (2 variáveis, 2 objetivos; bounds [-3, 3]^2)
- **VU2**: Função linear vs. quadrática deslocada (2 variáveis, 2 objetivos; bounds [-3, 3]^2)

### Problemas ZDT (Zitzler, Deb, e Thiele)

- **ZDT1**: Fronteira de Pareto convexa (30 variáveis, 2 objetivos)
- **ZDT2**: Fronteira de Pareto não convexa (30 variáveis, 2 objetivos)
- **ZDT3**: Fronteira de Pareto descontínua (30 variáveis, 2 objetivos)
- **ZDT4**: Fronteira de Pareto não convexa com muitos ótimos locais (10 variáveis, 2 objetivos)
- **ZDT6**: Fronteira de Pareto não convexa e não uniforme (10 variáveis, 2 objetivos)

### Problemas ZLT (Zitzler, Laumanns, Thiele)

- **ZLT1**: Funções quadráticas estritamente convexas deslocadas por objetivo (10 variáveis, 5 objetivos)


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
|AAS1  | Amaral, Assunção, Souza (2025)         | 2  | 2  | yes     | [cv, cv]                |
|AAS2  | Amaral, Assunção, Souza (2025)         | 2  | 2  | no      | [cv, cv]                |
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
|MGH9  | Moré, Garbow, Hillstrom (1981)         | 3  | 15 | yes     | [n-cv ×15]              |
|MGH16 | Moré, Garbow, Hillstrom (1981)         | 4  | 5  | yes     | [cv ×5]                 |
|MGH26 | Moré, Garbow, Hillstrom (1981)         | 4  | 4  | yes     | [n-cv ×4]               |
|MGH33 | Moré, Garbow, Hillstrom (1981)         | 10 | 10 | yes     | [cv ×10]                |
|MHHM1 | Simulation 1 in Mao, Hirasawa, Hu, Murata (2000)       | 1  | 3  | yes     | [cv, cv, cv]            |
|MHHM2 | Simulation 2 in Mao, Hirasawa, Hu, Murata (2000)       | 2  | 3  | yes     | [cv, cv, cv]            |
|MLF1  | Molyneaux, Favrat, Leyland (2001)                      | 1  | 2  | yes     | [n-cv, n-cv]            |
|MLF2  | Molyneaux, Favrat, Leyland (2001)                      | 2  | 2  | yes     | [n-cv, n-cv]            |
|MMR1  | Miglierina, Molho, Recchioni (2008)                    | 2  | 2  | yes     | [cv, n-cv]              |
|MMR2  | Miglierina, Molho, Recchioni (2008)                    | 2  | 2  | yes     | [cv, n-cv]              |
|MMR3  | Miglierina, Molho, Recchioni (2008)                    | 2  | 2  | yes     | [n-cv, n-cv]            |
|MMR4  | Miglierina, Molho, Recchioni (2008)                    | 3  | 2  | yes     | [n-cv, cv]              |
|MOP2  | MOP2 (ver Huband et al., 2006)                         | 2  | 2  | yes     | [cv, cv]                |
|MOP3  | MOP3 (ver Huband et al., 2006)                         | 2  | 2  | yes     | [n-cv, cv]              |
|MOP5  | MOP5 (ver Huband et al., 2006)                         | 2  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|MOP6  | MOP6 (ver Huband et al., 2006)                         | 2  | 2  | yes     | [cv, n-cv]              |
|MOP7  | MOP7 (ver Huband et al., 2006)                         | 2  | 3  | yes     | [cv, cv, cv]            |
|PNR   | Preuss, Naujoks, Rudolph (2006)        | 2  | 2  | yes     | [n-cv, estr cv]         |
|QV1   | Quagliarella & Vicini (1998)           | n  | 2  | yes     | [n-cv, n-cv]            |
|SD    | Stadler & Dauer (1992)                 | 4  | 2  | yes     | [n-cv, estr cv]         |
|SK1   | Socha & Kisiel-Dorohinicki (2002)      | 1  | 2  | yes     | [n-cv, n-cv]            |
|SK2   | Socha & Kisiel-Dorohinicki (2002)      | 4  | 2  | yes     | [cv, n-cv]              |
|SLCDT1| Schütze et al. (2008)                  | 2  | 2  | yes     | [n-cv, n-cv]            |
|SLCDT2| Schütze et al. (2008)                  | 10 | 3  | yes     | [n-cv, n-cv, n-cv]      |
|SP1   | Sefrioui & Perlaux (2000)              | 2  | 2  | yes     | [estr cv, estr cv]      |
|SSFYY2| Shim, Suh, Furukawa, Yagawa, Yoshimura (2002) | 1 | 2 | yes | [n-cv, estr cv]         |
|TKLY1 | Tan, Khor, Lee, Yang (2003)            | 4  | 2  | yes     | [n-cv, n-cv]            |
|Toi4  | Toint (1983)                           | 4  | 2  | yes     | [n-cv, n-cv]            |
|Toi8  | Toint (1983)                           | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|Toi9  | Toint (1983)                           | 4  | 4  | yes     | [n-cv, n-cv, n-cv, n-cv]|
|Toi10 | Toint (1983)                           | 4  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|VU1   | Valenzuela-Rendón & Uresti-Charre (1997) | 2 | 2 | yes     | [n-cv, estr cv]         |
|VU2   | Valenzuela-Rendón & Uresti-Charre (1997) | 2 | 2 | yes     | [n-cv, estr cv]         |
|ZDT1  | Ex. 1 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT2  | Ex. 2 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT3  | Ex. 3 de Zitzler et al. (2000)         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT4  | Ex. 4 de Zitzler et al. (2000)         | 10 | 2  | yes     | [cv, n-cv]              |
|ZDT6  | Ex. 6 de Zitzler et al. (2000)         | 10 | 2  | yes     | [n-cv, n-cv]            |
|ZLT1  | Zitzler, Laumanns, Thiele (2001)       | 10 | 5  | yes     | [estr cv ×5]            |

## Referências

- **AAS Problems**: V. S. Amaral, P. B. Assunção, D. R. Souza, "A Derivative-Free Proximal Method with Quadratic Modeling for Composite Multiobjective Optimization in the Hölder Setting," 2025.

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

- **MGH Problems**: J. J. Moré, B. S. Garbow, K. E. Hillstrom, "Testing Unconstrained Optimization Software," ACM Trans. Math. Softw., 7(1):17–41, 1981. DOI: 10.1145/355934.355936

- **MLF Problems**: A. Molyneaux, D. Favrat, and G. B. Leyland, "A New Clustering Evolutionary Multi-Objective Optimisation Technique," Third International Symposium on Adaptative Systems, Institute of Cybernetics, Mathematics and Physics, 2001, pp. 41–47. URL: https://infoscience.epfl.ch/handle/20.500.14299/215484

- **MMR Problems**: E. Miglierina, E. Molho, M. C. Recchioni, "Box-constrained multi-objective optimization: A gradient-like method without 'a priori' scalarization," European Journal of Operational Research, 188(3), 662–682, 2008. DOI: 10.1016/j.ejor.2007.05.037

- **MOP Problems (Van Veldhuizen set)**: S. Huband, P. Hingston, L. Barone, L. While, "A review of multiobjective test problems and a scalable test problem toolkit," IEEE Transactions on Evolutionary Computation, 10(5), 477–506, 2006. DOI: 10.1109/TEVC.2005.861417

- **PNR**: M. Preuss, B. Naujoks, G. Rudolph, "Pareto Set and EMOA Behavior for Simple Multimodal Multiobjective Functions," in PPSN IX, 2006. Springer, Berlin, Heidelberg. DOI: 10.1007/11844297_52

- **QV1**: D. Quagliarella, A. Vicini, "Sub-population policies for a parallel multiobjective genetic algorithm with applications to wing design," SMC'98 Conference Proceedings, 1998, pp. 3142–3147. DOI: 10.1109/ICSMC.1998.726485

- **SD**: W. Stadler, J. Dauer, "Multicriteria Optimization In Engineering: A Tutorial And Survey," in Structural Optimization: Status And Promise, AIAA, 1992. DOI: 10.2514/5.9781600866234.0209.0249

- **SK Problems**: K. Socha and M. Kisiel-Dorohinicki, "Agent-based evolutionary multiobjective optimisation," Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), Honolulu, HI, USA, 2002, pp. 109–114 vol.1. DOI: 10.1109/CEC.2002.1006218

- **SLCDT**: O. Schütze, M. Laumanns, C. A. Coello Coello, M. Dellnitz, E.-G. Talbi, "Convergence of stochastic search algorithms to finite size pareto set approximations," Journal of Global Optimization 41(4): 559–577, 2008. DOI: 10.1007/s10898-007-9265-7

- **SP**: M. Sefrioui, J. Perlaux, "Nash genetic algorithms: examples and applications," Proceedings of the 2000 Congress on Evolutionary Computation (CEC'00), 2000, pp. 509–516. DOI: 10.1109/CEC.2000.870339

- **SSFYY**: M.-B. Shim, M.-W. Suh, T. Furukawa, G. Yagawa, S. Yoshimura, "Pareto-based continuous evolutionary algorithms for multiobjective optimization," Engineering Computations, 19(1), 22–48, 2002. DOI: 10.1108/02644400210413649

- **TKLY Problems**: K. C. Tan, E. F. Khor, T. H. Lee, Y. J. Yang, "A Tabu-Based Exploratory Evolutionary Algorithm for Multiobjective Optimization," Artificial Intelligence Review, 19(3), 231–260, 2003. DOI: 10.1023/A:1022863019997

- **Toi Problems**: P. L. Toint, "Test problems for partially separable optimization and results for the routine PSPMIN," Technical Report 83-04, University of Namur, Belgium, 1983. https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf. See also: K. Mita, E. H. Fukuda, N. Yamashita, "Nonmonotone line searches for unconstrained multiobjective optimization problems," Journal of Global Optimization, 75, 63-90, 2019. https://doi.org/10.1007/s10898-019-00802-0

- **VU Problems**: M. Valenzuela-Rendón and E. Uresti-Charre, "A nongenerational genetic algorithm for multiobjective optimization," Proceedings of the 7th International Conference on Genetic Algorithms, 658-665, Jul. 1997.

- **ZDT Problems**: E. Zitzler, K. Deb, and L. Thiele, "Comparison of Multiobjective Evolutionary Algorithms: Empirical Results," Evolutionary Computation, vol. 8, no. 2, pp. 173-195, 2000. DOI: 10.1162/106365600568202

- **ZLT Problems**: Eckart Zitzler, Marco Laumanns, and Lothar Thiele, "SPEA2: Improving the strength Pareto evolutionary algorithm," 2001. Disponível em https://api.semanticscholar.org/CorpusID:16584254
