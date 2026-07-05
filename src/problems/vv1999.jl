"""
Van Veldhuizen’s MOP2–MOP7 (aggregation of problems from the literature).

Quoted context (Huband, S., Hingston, P., Barone, L., While, L. (2006)):

"In addition to a number of problems with side constraints, Van Veldhuizen employs seven multiobjective test problems from the literature, as shown in Table VIII. The original authors of MOP1–MOP7 are as follows: MOP1 is due to Schaffer [34]; MOP2 is due to Fonseca and Fleming [35] (originally parameters had domain [-2,2]); MOP3 is due to Poloni et al. [36]; MOP4 is based on Kursawe [37] (as indicated by Deb [27], the form employed by Van Veldhuizen, which is limited to three parameters, and uses the term instead of, proves more tractable to analysis); MOP5: due to Viennet et al. [38] (originally parameters had domain); MOP6 is constructed using Deb’s toolkit (F1, G1, H4); MOP7 is due to Viennet et al. [38] (originally parameters had domain [ 4,4])."

This file implements MOP2, MOP3, MOP5, MOP6 and MOP7:

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
    MOP2()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 1 - exp(-∑ᵢ(xᵢ - 1/√n)²)
    f₂(x) = 1 - exp(-∑ᵢ(xᵢ + 1/√n)²)
- Bounds: [-1, 1] for all variables
- Convexity: convex for both objectives
"""
function MOP2()
    meta = META["MOP2"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) / sqrt(T(n))
        s = zero(T)
        @inbounds for i in 1:n
            s += (x[i] - a)^2
        end
        return one(T) - exp(-s)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) / sqrt(T(n))
        s = zero(T)
        @inbounds for i in 1:n
            s += (x[i] + a)^2
        end
        return one(T) - exp(-s)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) / sqrt(T(n))
        s = zero(T)
        @inbounds for i in 1:n
            s += (x[i] - a)^2
        end
        fac = exp(-s)
        @inbounds for i in 1:n
            grad[i] = T(2) * (x[i] - a) * fac
        end
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) / sqrt(T(n))
        s = zero(T)
        @inbounds for i in 1:n
            s += (x[i] + a)^2
        end
        fac = exp(-s)
        @inbounds for i in 1:n
            grad[i] = T(2) * (x[i] + a) * fac
        end
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MOP3 -------------------------
"""
    MOP3()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = 1 + (A₁ - B₁(x))² + (A₂ - B₂(x))²
    f₂(x) = (x₁ + 3)² + (x₂ + 1)²
- Definitions:
    A₁ = 0.5sin(1) - 2cos(1) + sin(2) - 1.5cos(2)
    A₂ = 1.5sin(1) - cos(1) + 2sin(2) - 0.5cos(2)
    B₁(x) = 0.5sin(x₁) - 2cos(x₁) + sin(x₂) - 1.5cos(x₂)
    B₂(x) = 1.5sin(x₁) - cos(x₁) + 2sin(x₂) - 0.5cos(x₂)
- Bounds: [-π, π] for all variables
- Convexity: [non-convex, convex]
"""
function MOP3()
    meta = META["MOP3"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        A1 = T(0.5) * sin(one(T)) - T(2) * cos(one(T)) + sin(T(2)) - T(1.5) * cos(T(2))
        A2 = T(1.5) * sin(one(T)) - cos(one(T)) + T(2) * sin(T(2)) - T(0.5) * cos(T(2))
        B1 = T(0.5) * sin(x[1]) - T(2) * cos(x[1]) + sin(x[2]) - T(1.5) * cos(x[2])
        B2 = T(1.5) * sin(x[1]) - cos(x[1]) + T(2) * sin(x[2]) - T(0.5) * cos(x[2])
        return one(T) + (A1 - B1)^2 + (A2 - B2)^2
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] + T(3))^2 + (x[2] + one(T))^2
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        A1 = T(0.5) * sin(one(T)) - T(2) * cos(one(T)) + sin(T(2)) - T(1.5) * cos(T(2))
        A2 = T(1.5) * sin(one(T)) - cos(one(T)) + T(2) * sin(T(2)) - T(0.5) * cos(T(2))
        B1 = T(0.5) * sin(x[1]) - T(2) * cos(x[1]) + sin(x[2]) - T(1.5) * cos(x[2])
        B2 = T(1.5) * sin(x[1]) - cos(x[1]) + T(2) * sin(x[2]) - T(0.5) * cos(x[2])
        grad[1] = T(2) * (A1 - B1) * (-T(0.5) * cos(x[1]) - T(2) * sin(x[1])) +
                  T(2) * (A2 - B2) * (-T(1.5) * cos(x[1]) - sin(x[1]))
        grad[2] = T(2) * (A1 - B1) * (-cos(x[2]) - T(1.5) * sin(x[2])) +
                  T(2) * (A2 - B2) * (-T(2) * cos(x[2]) - T(0.5) * sin(x[2]))
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] + T(3))
        grad[2] = T(2) * (x[2] + one(T))
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (fill(-π, n), fill(π, n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MOP5 -------------------------
"""
    MOP5()

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = 0.5(x₁² + x₂²) + sin(x₁² + x₂²)
    f₂(x) = (3x₁ - 2x₂ + 4)² / 8 + (x₁ - x₂ + 1)² / 27 + 15
    f₃(x) = 1 / (x₁² + x₂² + 1) - 1.1exp(-(x₁² + x₂²))
- Bounds: [-1, 1] for all variables
- Convexity: non-convex for all objectives
"""
function MOP5()
    meta = META["MOP5"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        r2 = x[1]^2 + x[2]^2
        return T(0.5) * r2 + sin(r2)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (T(3) * x[1] - T(2) * x[2] + T(4))^2 / T(8) +
               (x[1] - x[2] + one(T))^2 / T(27) + T(15)
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        r2 = x[1]^2 + x[2]^2
        return one(T) / (r2 + one(T)) - T(1.1) * exp(-r2)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        c = cos(x[1]^2 + x[2]^2)
        grad[1] = x[1] + T(2) * x[1] * c
        grad[2] = x[2] + T(2) * x[2] * c
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(3) * (T(3) * x[1] - T(2) * x[2] + T(4)) / T(4) +
                  T(2) * (x[1] - x[2] + one(T)) / T(27)
        grad[2] = -T(2) * (T(3) * x[1] - T(2) * x[2] + T(4)) / T(4) -
                  T(2) * (x[1] - x[2] + one(T)) / T(27)
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        r2 = x[1]^2 + x[2]^2
        denom = (r2 + one(T))^2
        e = exp(-r2)
        grad[1] = -T(2) * x[1] / denom + T(2.2) * x[1] * e
        grad[2] = -T(2) * x[2] / denom + T(2.2) * x[2] * e
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-1.0, n), fill(1.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end

# ------------------------- MOP6 -------------------------
"""
    MOP6()

Problem characteristics summary:
- 2 variables
- 2 objectives
- Objectives:
    f₁(x) = x₁
    f₂(x) = a(1 - (x₁/a)² - (x₁/a)sin(8πx₁)), where a = 1 + 10x₂
- Bounds: [0, 1] for all variables
- Convexity: [convex, non-convex]
"""
function MOP6()
    meta = META["MOP6"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return x[1]
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) + T(10) * x[2]
        t = x[1] / a
        return a * (one(T) - t^2 - t * sin(T(8) * T(π) * x[1]))
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = one(T)
        grad[2] = zero(T)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        a = one(T) + T(10) * x[2]
        t = x[1] / a
        angle = T(8) * T(π) * x[1]
        b = sin(angle)
        grad[1] = -T(2) * t - b - T(8) * T(π) * x[1] * cos(angle)
        grad[2] = T(10) * (one(T) - t^2 - t * b) + T(10) * x[1] / a * (T(2) * t + b)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2);
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = (df1_dx, df2_dx),
    )
end

# ------------------------- MOP7 -------------------------
"""
    MOP7()

Problem characteristics summary:
- 2 variables
- 3 objectives
- Objectives:
    f₁(x) = (x₁ - 2)² / 2 + (x₂ + 1)² / 13 + 3
    f₂(x) = (x₁ + x₂ - 3)² / 36 + (-x₁ + x₂ + 2)² / 8 - 17
    f₃(x) = (x₁ + 2x₂ - 1)² / 175 + (-x₁ + 2x₂)² / 17 - 13
- Bounds: [-400, 400] for all variables
- Convexity: convex for all objectives
"""
function MOP7()
    meta = META["MOP7"]
    n = default_nvar(meta.dimension)
    m = default_nobj(meta.dimension)

    f1 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] - T(2))^2 / T(2) + (x[2] + one(T))^2 / T(13) + T(3)
    end

    f2 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] + x[2] - T(3))^2 / T(36) + (-x[1] + x[2] + T(2))^2 / T(8) - T(17)
    end

    f3 = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        return (x[1] + T(2) * x[2] - one(T))^2 / T(175) +
               (-x[1] + T(2) * x[2])^2 / T(17) - T(13)
    end

    df1_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = x[1] - T(2)
        grad[2] = T(2) * (x[2] + one(T)) / T(13)
        return grad
    end

    df2_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = (x[1] + x[2] - T(3)) / T(18) - (-x[1] + x[2] + T(2)) / T(4)
        grad[2] = (x[1] + x[2] - T(3)) / T(18) + (-x[1] + x[2] + T(2)) / T(4)
        return grad
    end

    df3_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
        grad[1] = T(2) * (x[1] + T(2) * x[2] - one(T)) / T(175) -
                  T(2) * (-x[1] + T(2) * x[2]) / T(17)
        grad[2] = T(4) * (x[1] + T(2) * x[2] - one(T)) / T(175) +
                  T(4) * (-x[1] + T(2) * x[2]) / T(17)
        return grad
    end

    return MOProblem(
        n, m, (f1, f2, f3);
        name = meta.name,
        bounds = (fill(-400.0, n), fill(400.0, n)),
        jacobian = (df1_dx, df2_dx, df3_dx),
    )
end