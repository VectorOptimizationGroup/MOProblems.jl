"""
DTLZ scalable multiobjective benchmark problems.

This file implements `DTLZ1`--`DTLZ5` from Deb, Thiele, Laumanns, and
Zitzler's scalable test-problem family.
"""

"""
    DTLZ1(; k::Int = 5, m::Int = 3)

Return the DTLZ1 benchmark with parameters `k` and `m`.

The instance has `nvar = k + m - 1`, `nobj = m`, bounds `[0, 1]^n`, and a
registered analytical Jacobian. The default instance has `nvar = 7` and
`nobj = 3`.
"""
function DTLZ1(; k::Int = 5, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ1"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20) * π * (x[i] - T(0.5)))
        end
        return T(100) * (T(k) + sum_term)
    end
    
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = T(0.5) * (one(T) + gx)
            
            for j in 1:(m-i)
                result *= x[j]
            end
            
            if i > 1
                result *= (one(T) - x[m-i+1])
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            
            gx = g(x)
            
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= x[j]
            end
            
            if i > 1
                prod_term *= (one(T) - x[m-i+1])
            end
            
            for j in 1:(m-i)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= x[l]
                    end
                end
                if i > 1
                    other_prod *= (one(T) - x[m-i+1])
                end
                grad[j] = T(0.5) * (one(T) + gx) * other_prod
            end
            
            if i > 1
                grad[m-i+1] = -T(0.5) * (one(T) + gx) * prod_term / (one(T) - x[m-i+1])
            end
            
            for j in m:n
                dg_dx = T(100) * (T(2) * (x[j] - T(0.5)) + T(20) * π * sin(T(20) * π * (x[j] - T(0.5))))
                grad[j] = T(0.5) * dg_dx * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = gradients,
    )
end

"""
    DTLZ2(; k::Int = 10, m::Int = 3)

Return the DTLZ2 benchmark with parameters `k` and `m`.

The instance has `nvar = k + m - 1`, `nobj = m`, bounds `[0, 1]^n`, and a
registered analytical Jacobian. The default instance has `nvar = 12` and
`nobj = 3`.
"""
function DTLZ2(; k::Int = 10, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ2"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = one(T) + gx
            
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2))
            end
            
            if i > 1
                result *= sin(x[m-i+1] * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            gx = g(x)
            
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2))
            end
            
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2))
            end
            
            for j in 1:(m-i)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l] * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * sin(x[j] * π / T(2)) * other_prod
            end
            
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * cos(x[m-i+1] * π / T(2)) * other_prod
            end
            
            for j in m:n
                grad[j] = T(2) * (x[j] - T(0.5)) * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = gradients,
    )
end 

"""
    DTLZ3(; k::Int = 10, m::Int = 3)

Return the DTLZ3 benchmark with parameters `k` and `m`.

The instance has `nvar = k + m - 1`, `nobj = m`, bounds `[0, 1]^n`, and a
registered analytical Jacobian. The default instance has `nvar = 12` and
`nobj = 3`.
"""
function DTLZ3(; k::Int = 10, m::Int = 3)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ3"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2 - cos(T(20) * π * (x[i] - T(0.5)))
        end
        return T(100) * (T(k) + sum_term)
    end
    
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            gx = g(x)
            result = one(T) + gx
            
            for j in 1:(m-i)
                result *= cos(x[j] * π / T(2))
            end
            
            if i > 1
                result *= sin(x[m-i+1] * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            gx = g(x)
            
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j] * π / T(2))
            end
            
            if i > 1
                prod_term *= sin(x[m-i+1] * π / T(2))
            end
            
            for j in 1:(m-i)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l] * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1] * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * sin(x[j] * π / T(2)) * other_prod
            end
            
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j] * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * cos(x[m-i+1] * π / T(2)) * other_prod
            end
            
            for j in m:n
                dg_dx = T(100) * (T(2) * (x[j] - T(0.5)) + T(20) * π * sin(T(20) * π * (x[j] - T(0.5))))
                grad[j] = dg_dx * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = gradients,
    )
end 

"""
    DTLZ4(; k::Int = 10, m::Int = 3, alpha::Real = 100.0)

Return the DTLZ4 benchmark with parameters `k`, `m`, and `alpha`.

The instance has `nvar = k + m - 1`, `nobj = m`, bounds `[0, 1]^n`, and a
registered analytical Jacobian. The default instance has `nvar = 12` and
`nobj = 3`.
"""
function DTLZ4(; k::Int = 10, m::Int = 3, alpha::Real = 100.0)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    @assert alpha > 0 "alpha must be positive"
    
    n = k + m - 1
    meta = META["DTLZ4"]
    
    g = function (x::AbstractVector{T}) where {T <: AbstractFloat}
        sum_term = zero(T)
        for i in m:n
            sum_term += (x[i] - T(0.5))^2
        end
        return sum_term
    end
    
    objectives = Function[]
    
    for i in 1:m
        f_i = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            alpha_T = T(alpha)
            gx = g(x)
            result = one(T) + gx
            
            for j in 1:(m-i)
                result *= cos(x[j]^alpha_T * π / T(2))
            end
            
            if i > 1
                result *= sin(x[m-i+1]^alpha_T * π / T(2))
            end
            
            return result
        end
        push!(objectives, f_i)
    end
    
    gradients = Function[]
    
    for i in 1:m
        df_i_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            alpha_T = T(alpha)
            gx = g(x)
            
            prod_term = one(T)
            for j in 1:(m-i)
                prod_term *= cos(x[j]^alpha_T * π / T(2))
            end
            
            if i > 1
                prod_term *= sin(x[m-i+1]^alpha_T * π / T(2))
            end
            
            for j in 1:(m-i)
                other_prod = one(T)
                for l in 1:(m-i)
                    if l != j
                        other_prod *= cos(x[l]^alpha_T * π / T(2))
                    end
                end
                if i > 1
                    other_prod *= sin(x[m-i+1]^alpha_T * π / T(2))
                end
                grad[j] = (one(T) + gx) * (-π / T(2)) * alpha_T * x[j]^(alpha_T - one(T)) * sin(x[j]^alpha_T * π / T(2)) * other_prod
            end
            
            if i > 1
                other_prod = one(T)
                for j in 1:(m-i)
                    other_prod *= cos(x[j]^alpha_T * π / T(2))
                end
                grad[m-i+1] = (one(T) + gx) * (π / T(2)) * alpha_T * x[m-i+1]^(alpha_T - one(T)) * cos(x[m-i+1]^alpha_T * π / T(2)) * other_prod
            end
            
            for j in m:n
                grad[j] = T(2) * (x[j] - T(0.5)) * prod_term
            end
            
            return grad
        end
        push!(gradients, df_i_dx)
    end
    
    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = gradients,
    )
end 

"""
    DTLZ5(; k::Int = 10, m::Int = 5)

Return the DTLZ5 benchmark with parameters `k` and `m`.

The instance has `nvar = k + m - 1`, `nobj = m`, bounds `[0, 1]^n`, and a
registered analytical Jacobian. The default instance has `nvar = 14` and
`nobj = 5`.
"""
function DTLZ5(; k::Int = 10, m::Int = 5)
    k >= 1 || throw(ArgumentError("k must be at least 1"))
    m >= 2 || throw(ArgumentError("m must be at least 2"))
    
    n = k + m - 1
    meta = META["DTLZ5"]
    
    objectives = Function[]
    
    for ind in 1:m
        f_ind = function (x::AbstractVector{T}) where {T <: AbstractFloat}
            faux = zero(T)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            a = π / (T(4) * (one(T) + faux))
            
            f = one(T) + faux
            for i in 1:(m-ind)
                theta_i = i == 1 ? x[1] : a * (one(T) + T(2) * faux * x[i])
                f *= cos(theta_i * π / T(2))
            end
            
            if ind > 1
                theta_i = m - ind + 1 == 1 ? x[1] : a * (one(T) + T(2) * faux * x[m-ind+1])
                f *= sin(theta_i * π / T(2))
            end
            
            return f
        end
        push!(objectives, f_ind)
    end
    
    gradients = Function[]
    
    for ind in 1:m
        df_ind_dx = function (grad::AbstractVector{T}, x::AbstractVector{T}) where {T <: AbstractFloat}
            fill!(grad, zero(T))
            
            faux = zero(T)
            for i in m:n
                faux += (x[i] - T(0.5))^2
            end
            
            a = π / (T(4) * (one(T) + faux))
            b = a * T(2) * faux
            
            faux = one(T) + faux
            
            for i in 1:(m-ind)
                grad[i] = faux
            end
            
            for i in 1:(m-ind)
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[j])
                    if j == i
                        thetader_i = i == 1 ? one(T) : b
                        grad[i] = -grad[i] * π / T(2) * thetader_i * sin(theta_j * π / T(2))
                    else
                        grad[i] *= cos(theta_j * π / T(2))
                    end
                end
                if ind > 1
                    theta_i = m - ind + 1 == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[m-ind+1])
                    grad[i] *= sin(theta_i * π / T(2))
                end
            end
            
            if ind > 1
                idx = m - ind + 1
                theta_idx = idx == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[idx])
                thetader_idx = idx == 1 ? one(T) : b
                grad[idx] = faux * π / T(2) * thetader_idx * cos(theta_idx * π / T(2))
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (faux - one(T)) * x[j])
                    grad[idx] *= cos(theta_j * π / T(2))
                end
            end
            
            one_plus_g = faux

            # For tail variables, account for both the direct `(1 + g)` factor
            # and the dependence of transformed angles on `g`.
            for i in m:n
                dg_dx = T(2) * (x[i] - T(0.5))

                cos_prod = one(T)
                for j in 1:(m-ind)
                    theta_j = j == 1 ? x[1] : a * (one(T) + T(2) * (one_plus_g - one(T)) * x[j])
                    cos_prod *= cos(theta_j * π / T(2))
                end

                sin_factor = one(T)
                if ind > 1
                    idx = m - ind + 1
                    theta_idx = idx == 1 ? x[1] : a * (one(T) + T(2) * (one_plus_g - one(T)) * x[idx])
                    sin_factor = sin(theta_idx * π / T(2))
                end

                deriv = dg_dx * cos_prod * sin_factor

                sum_term = zero(T)
                for j in 2:(m-1)
                    if j <= m - ind
                        theta_j = a * (one(T) + T(2) * (one_plus_g - one(T)) * x[j])
                        dtheta = dg_dx * a * ( - (one(T) + T(2) * (one_plus_g - one(T)) * x[j]) / one_plus_g + T(2) * x[j] )
                        sum_term += (-π / T(2)) * tan(theta_j * π / T(2)) * dtheta
                    end
                end
                dcos_prod = cos_prod * sum_term

                dsin_factor = zero(T)
                if ind > 1
                    k_idx = m - ind + 1
                    if k_idx >= 2
                        theta_k = a * (one(T) + T(2) * (one_plus_g - one(T)) * x[k_idx])
                        dtheta_k = dg_dx * a * ( - (one(T) + T(2) * (one_plus_g - one(T)) * x[k_idx]) / one_plus_g + T(2) * x[k_idx] )
                        dsin_factor = (π / T(2)) * cos(theta_k * π / T(2)) * dtheta_k
                    end
                end

                deriv += one_plus_g * (dcos_prod * sin_factor + cos_prod * dsin_factor)
                grad[i] = deriv
            end
            
            return grad
        end
        push!(gradients, df_ind_dx)
    end
    
    return MOProblem(
        n,
        m,
        objectives;
        name = meta.name,
        bounds = (zeros(n), ones(n)),
        jacobian = gradients,
    )
end
