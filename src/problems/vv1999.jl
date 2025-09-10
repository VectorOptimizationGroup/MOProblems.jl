"""
Van Veldhuizen’s MOP2–MOP7 (aggregation of problems from the literature).

Quoted context (Huband et al., 2006):

"In addition to a number of problems with side constraints, Van Veldhuizen employs seven multiobjective test problems from the literature, as shown in Table VIII. The original authors of MOP1–MOP7 are as follows: MOP1 is due to Schaffer [34]; MOP2 is due to Fonseca and Fleming [35] (originally parameters had domain [ 2,2]); MOP3 is due to Poloni et al. [36]; MOP4 is based on Kursawe [37] (as indicated by Deb [27], the form employed by Van Veldhuizen, which is limited to three parameters, and uses the term instead of, proves more tractable to analysis); MOP5: due to Viennet et al. [38] (originally parameters had domain); MOP6 is constructed using Deb’s toolkit (F1, G1, H4); MOP7 is due to Viennet et al. [38] (originally parameters had domain [ 4,4])."

This file implements MOP2, MOP3, MOP5, MOP6 and MOP7 as present in `Souza-DR/tempfunc.f90` and integrates them into the MOProblems.jl API.

References
- Huband, S., Hingston, P., Barone, L., While, L. (2006). A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5), 477–506. DOI: 10.1109/TEVC.2005.861417.
- Van Veldhuizen, D. A. (1999). Multiobjective Evolutionary Algorithms: Classifications, Analyses, and New Innovations. Ph.D. thesis, Air Force Institute of Technology. https://scholar.afit.edu/etd/5128
- Deb, K. (2001). Multi-Objective Optimization Using Evolutionary Algorithms. John Wiley & Sons, Inc. ISBN: 047187339X.
- Schaffer, J. D. (1985). Multiple Objective Optimization with Vector Evaluated Genetic Algorithms. In Proceedings of the 1st International Conference on Genetic Algorithms, pp. 93–100. L. Erlbaum Associates Inc.
- Fonseca, C. M., & Fleming, P. J. (1995). Multiobjective genetic algorithms made easy: selection sharing and mating restriction. First International Conference on Genetic Algorithms in Engineering Systems: Innovations and Applications, pp. 45–52. DOI: 10.1049/cp:19951023
- Poloni, C., Mosetti, G., & Contessi, S. (1996). Multi Objective Optimization by GAs: Application to System and Component Design. In Advances in Engineering Software (Wiley), ISBN: 0471962260. URL: http://hdl.handle.net/11368/2545753
- Kursawe, F. (1991). A variant of evolution strategies for vector optimization. In Parallel Problem Solving from Nature (PPSN I), pp. 193–197. Springer, Berlin, Heidelberg. ISBN: 978-3-540-70652-6.
- Viennet, R., Fonteix, C., & Marc, I. (1996). Multicriteria optimization using a genetic algorithm for determining a Pareto set. International Journal of Systems Science, 27(2), 255–260. https://doi.org/10.1080/00207729608929211
"""

# ------------------------- MOP2 -------------------------
"""
    MOP2(; T::Type{<:AbstractFloat}=Float64)

Two-objective problem (Fonseca & Fleming, 1995 variant).

Characteristics:
- 2 variables
- 2 objectives
- Bounds: [-1, 1]^2
"""
function MOP2(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MOP2"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = function (x)
        s = zero(T)
        a = T(1) / sqrt(T(n))
        for i in 1:n
            s += (x[i] - a)^2
        end
        return T(1) - exp(-s)
    end

    f2 = function (x)
        s = zero(T)
        a = T(1) / sqrt(T(n))
        for i in 1:n
            s += (x[i] + a)^2
        end
        return T(1) - exp(-s)
    end

    df1 = function (x)
        g = zeros(T, n)
        a = T(1) / sqrt(T(n))
        s = zero(T)
        for i in 1:n
            s += (x[i] - a)^2
        end
        fac = exp(-s)
        for i in 1:n
            g[i] = T(2) * (x[i] - a) * fac
        end
        return g
    end

    df2 = function (x)
        g = zeros(T, n)
        a = T(1) / sqrt(T(n))
        s = zero(T)
        for i in 1:n
            s += (x[i] + a)^2
        end
        fac = exp(-s)
        for i in 1:n
            g[i] = T(2) * (x[i] + a) * fac
        end
        return g
    end

    jac = x -> [df1(x)'; df2(x)']
    bounds = (fill(T(-1), n), fill(T(1), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end


# ------------------------- MOP3 -------------------------
"""
    MOP3(; T::Type{<:AbstractFloat}=Float64)

Two-objective problem (Poloni et al., 1996 variant).

Characteristics:
- 2 variables
- 2 objectives
- Bounds: [-π, π]^2
"""
function MOP3(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MOP3"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = function (x)
        A1 = T(0.5) * sin(T(1)) - T(2) * cos(T(1)) + sin(T(2)) - T(1.5) * cos(T(2))
        A2 = T(1.5) * sin(T(1)) - cos(T(1)) + T(2) * sin(T(2)) - T(0.5) * cos(T(2))
        B1 = T(0.5) * sin(x[1]) - T(2) * cos(x[1]) + sin(x[2]) - T(1.5) * cos(x[2])
        B2 = T(1.5) * sin(x[1]) - cos(x[1]) + T(2) * sin(x[2]) - T(0.5) * cos(x[2])
        return T(1) + (A1 - B1)^2 + (A2 - B2)^2
    end

    f2 = x -> (x[1] + T(3))^2 + (x[2] + T(1))^2

    df1 = function (x)
        A1 = T(0.5) * sin(T(1)) - T(2) * cos(T(1)) + sin(T(2)) - T(1.5) * cos(T(2))
        A2 = T(1.5) * sin(T(1)) - cos(T(1)) + T(2) * sin(T(2)) - T(0.5) * cos(T(2))
        B1 = T(0.5) * sin(x[1]) - T(2) * cos(x[1]) + sin(x[2]) - T(1.5) * cos(x[2])
        B2 = T(1.5) * sin(x[1]) - cos(x[1]) + T(2) * sin(x[2]) - T(0.5) * cos(x[2])
        g1 = T(2) * (A1 - B1) * (-T(0.5) * cos(x[1]) - T(2) * sin(x[1])) +
             T(2) * (A2 - B2) * (-T(1.5) * cos(x[1]) - sin(x[1]))
        g2 = T(2) * (A1 - B1) * (-cos(x[2]) - T(1.5) * sin(x[2])) +
             T(2) * (A2 - B2) * (-T(2) * cos(x[2]) - T(0.5) * sin(x[2]))
        return T[g1, g2]
    end

    df2 = x -> T[T(2) * (x[1] + T(3)), T(2) * (x[2] + T(1))]

    jac = x -> [df1(x)'; df2(x)']
    bounds = (fill(-T(pi), n), fill(T(pi), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end


# ------------------------- MOP5 -------------------------
"""
    MOP5(; T::Type{<:AbstractFloat}=Float64)

Three-objective problem (Viennet et al., 1996 variant).

Characteristics:
- 2 variables
- 3 objectives
- Bounds: [-1, 1]^2
"""
function MOP5(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MOP5"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> T(0.5) * (x[1]^2 + x[2]^2) + sin(x[1]^2 + x[2]^2)

    f2 = x -> ((T(3) * x[1] - T(2) * x[2] + T(4))^2) / T(8) +
                 ((x[1] - x[2] + T(1))^2) / T(27) + T(15)

    f3 = x -> T(1) / (x[1]^2 + x[2]^2 + T(1)) - T(1.1) * exp(-x[1]^2 - x[2]^2)

    df1 = x -> begin
        c = cos(x[1]^2 + x[2]^2)
        return T[
            x[1] + T(2) * x[1] * c,
            x[2] + T(2) * x[2] * c,
        ]
    end

    df2 = x -> begin
        g1 = T(3) * (T(3) * x[1] - T(2) * x[2] + T(4)) / T(4) +
             T(2) * (x[1] - x[2] + T(1)) / T(27)
        g2 = -T(2) * (T(3) * x[1] - T(2) * x[2] + T(4)) / T(4) -
             T(2) * (x[1] - x[2] + T(1)) / T(27)
        return T[g1, g2]
    end

    df3 = x -> begin
        denom = (x[1]^2 + x[2]^2 + T(1))^2
        e = exp(-x[1]^2 - x[2]^2)
        return T[
            -T(2) * x[1] / denom + T(2.2) * x[1] * e,
            -T(2) * x[2] / denom + T(2.2) * x[2] * e,
        ]
    end

    jac = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1(x)
        J[2, :] = df2(x)
        J[3, :] = df3(x)
        return J
    end

    bounds = (fill(T(-1), n), fill(T(1), n))

    return MOProblem(
        n, m, [f1, f2, f3];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2, df3],
        convexity = meta[:convexity],
    )
end


# ------------------------- MOP6 -------------------------
"""
    MOP6(; T::Type{<:AbstractFloat}=Float64)

Two-objective problem constructed from Deb’s toolkit (F1, G1, H4).

Characteristics:
- 2 variables
- 2 objectives
- Bounds: [0, 1]^2
"""
function MOP6(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MOP6"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> x[1]

    f2 = function (x)
        a = T(1) + T(10) * x[2]
        t = x[1] / a
        return a * (T(1) - t^2 - t * sin(T(8) * π * x[1]))
    end

    df1 = x -> T[T(1), T(0)]

    df2 = function (x)
        a = T(1) + T(10) * x[2]
        b = sin(T(8) * π * x[1])
        t = x[1] / a
        g1 = -T(2) * t - b - T(8) * π * x[1] * cos(T(8) * π * x[1])
        g2 = T(10) * (T(1) - t^2 - t * b) + T(10) * x[1] / a * (T(2) * t + b)
        return T[g1, g2]
    end

    jac = x -> [df1(x)'; df2(x)']
    bounds = (fill(T(0), n), fill(T(1), n))

    return MOProblem(
        n, m, [f1, f2];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2],
        convexity = meta[:convexity],
    )
end


# ------------------------- MOP7 -------------------------
"""
    MOP7(; T::Type{<:AbstractFloat}=Float64)

Three-objective problem (Viennet et al., 1996 variant).

Characteristics:
- 2 variables
- 3 objectives
- Bounds: [-400, 400]^2
"""
function MOP7(; T::Type{<:AbstractFloat}=Float64)
    meta = META["MOP7"]
    n = meta[:nvar]
    m = meta[:nobj]

    f1 = x -> (x[1] - T(2))^2 / T(2) + (x[2] + T(1))^2 / T(13) + T(3)
    f2 = x -> (x[1] + x[2] - T(3))^2 / T(36) + (-x[1] + x[2] + T(2))^2 / T(8) - T(17)
    f3 = x -> (x[1] + T(2) * x[2] - T(1))^2 / T(175) + (-x[1] + T(2) * x[2])^2 / T(17) - T(13)

    df1 = x -> T[
        (x[1] - T(2)),
        T(2) * (x[2] + T(1)) / T(13),
    ]

    df2 = x -> T[
        (x[1] + x[2] - T(3)) / T(18) - (-x[1] + x[2] + T(2)) / T(4),
        (x[1] + x[2] - T(3)) / T(18) + (-x[1] + x[2] + T(2)) / T(4),
    ]

    df3 = x -> T[
        T(2) * (x[1] + T(2) * x[2] - T(1)) / T(175) - T(2) * (-x[1] + T(2) * x[2]) / T(17),
        T(4) * (x[1] + T(2) * x[2] - T(1)) / T(175) + T(4) * (-x[1] + T(2) * x[2]) / T(17),
    ]

    jac = x -> begin
        J = zeros(T, m, n)
        J[1, :] = df1(x)
        J[2, :] = df2(x)
        J[3, :] = df3(x)
        return J
    end

    bounds = (fill(T(-400), n), fill(T(400), n))

    return MOProblem(
        n, m, [f1, f2, f3];
        name = meta[:name], origin = meta[:origin], minimize = meta[:minimize],
        has_bounds = meta[:has_bounds], bounds = bounds,
        has_jacobian = true, jacobian = jac, jacobian_by_row = [df1, df2, df3],
        convexity = meta[:convexity],
    )
end
