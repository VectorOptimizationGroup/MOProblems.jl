"""
    _check_dimension(prob::MOProblem, x::AbstractVector)

Validate that `x` has length `prob.nvar`.
"""
function _check_dimension(prob::MOProblem, x::AbstractVector)
    length(x) == prob.nvar || throw(DimensionMismatch(
        "length(x) = $(length(x)); expected $(prob.nvar)",
    ))
    return nothing
end

"""
    _check_output_length(y::AbstractVector, expected::Int, name::String)

Validate that output vector `y` has the expected length.
"""
function _check_output_length(y::AbstractVector, expected::Int, name::String)
    length(y) == expected || throw(DimensionMismatch(
        "length($name) = $(length(y)); expected $expected",
    ))
    return nothing
end

"""
    _check_output_size(A::AbstractMatrix, expected::Tuple{Int, Int}, name::String)

Validate that output matrix `A` has the expected size.
"""
function _check_output_size(A::AbstractMatrix, expected::Tuple{Int, Int}, name::String)
    size(A) == expected || throw(DimensionMismatch(
        "size($name) = $(size(A)); expected $expected",
    ))
    return nothing
end

"""
    eval_f!(y, prob::MOProblem, x::AbstractVector{T})

Evaluate all objective functions of `prob` at `x` and write the result to `y`.

`x` must have length `prob.nvar`, and `y` must have length `prob.nobj`.
Values are stored using the numeric type `T` of `x`.

Returns `y`.
"""
function eval_f!(y::AbstractVector{T}, prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(y, prob.nobj, "y")
    for i in 1:prob.nobj
        y[i] = prob.f[i](x)
    end
    return y
end

"""
    eval_f(prob::MOProblem, x::AbstractVector{T})

Evaluate all objective functions of `prob` at `x`.

`x` must have length `prob.nvar`. The returned vector has length `prob.nobj`
and element type `T`.
"""
function eval_f(prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    return eval_f!(Vector{T}(undef, prob.nobj), prob, x)
end

"""
    eval_f(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the `i`-th objective function of `prob` at `x`.

`x` must have length `prob.nvar`, and `i` must be between `1` and `prob.nobj`.
The returned scalar has type `T`.
"""
function eval_f(prob::MOProblem, x::AbstractVector{T}, i::Int) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    return T(prob.f[i](x))
end

"""
    eval_c!(values, prob::MOProblem, x::AbstractVector{T})

Evaluate the constraint mapping `c(x)` and write it to `values`.

`x` must have length `prob.nvar`, and `values` must have length `prob.ncon`.
Each constraint is interpreted together with `prob.lcon` and `prob.ucon` as
`prob.lcon[i] <= c_i(x) <= prob.ucon[i]`.

Returns `values`.
"""
function eval_c!(
    values::AbstractVector{T},
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(values, prob.ncon, "values")
    for i in 1:prob.ncon
        values[i] = prob.c[i](x)
    end
    return values
end

"""
    eval_c(prob::MOProblem, x::AbstractVector{T})

Evaluate the constraint mapping `c(x)`.

The returned vector has length `prob.ncon` and element type `T`. An
unconstrained problem returns an empty vector.
"""
function eval_c(prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    return eval_c!(Vector{T}(undef, prob.ncon), prob, x)
end

"""
    eval_c(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the `i`-th constraint function at `x`.
"""
function eval_c(prob::MOProblem, x::AbstractVector{T}, i::Int) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    return T(prob.c[i](x))
end

"""
    eval_jacobian!(J, prob::MOProblem, x::AbstractVector{T})

Evaluate the registered Jacobian matrix of the objective functions at `x` and
write the result to `J`.

`x` must have length `prob.nvar`, and `J` must have size
`(prob.nobj, prob.nvar)`. Each row of `J` is the gradient of one objective.

Returns `J`. Throws an error if `prob` has no registered analytical Jacobian.
"""
function eval_jacobian!(J::AbstractMatrix{T}, prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_size(J, (prob.nobj, prob.nvar), "J")

    if !isnothing(prob.jacobian)
        for i in 1:prob.nobj
            prob.jacobian[i](view(J, i, :), x)
        end
        return J
    end

    error("Analytical Jacobian is not registered for problem '$(prob.name)'.")
end

"""
    eval_jacobian(prob::MOProblem, x::AbstractVector{T})

Evaluate the Jacobian matrix of the objective functions at `x`.

`x` must have length `prob.nvar`. The returned matrix has size
`(prob.nobj, prob.nvar)` and element type `T`; each row is the gradient of one
objective.

Throws an error if `prob` has no registered analytical Jacobian.
"""
function eval_jacobian(prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    return eval_jacobian!(Matrix{T}(undef, prob.nobj, prob.nvar), prob, x)
end

"""
    eval_jacobian_row!(row, prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the `i`-th row of the Jacobian matrix at `x` and write the result to
`row`.

`x` and `row` must both have length `prob.nvar`, and `i` must be between `1`
and `prob.nobj`.

Returns `row`. Throws an error if `prob` has no registered analytical Jacobian.
"""
function eval_jacobian_row!(
    row::AbstractVector{T},
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(row, prob.nvar, "row")

    if !isnothing(prob.jacobian)
        prob.jacobian[i](row, x)
        return row
    end

    error("Analytical Jacobian is not registered for problem '$(prob.name)'.")
end

"""
    eval_jacobian_row(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the `i`-th row of the Jacobian matrix at `x`.

`x` must have length `prob.nvar`, and `i` must be between `1` and `prob.nobj`.
The returned vector has length `prob.nvar` and element type `T`.

Throws an error if `prob` has no registered analytical Jacobian.
"""
function eval_jacobian_row(prob::MOProblem, x::AbstractVector{T}, i::Int) where {T <: AbstractFloat}
    return eval_jacobian_row!(Vector{T}(undef, prob.nvar), prob, x, i)
end

"""
    eval_constraint_jacobian!(J, prob::MOProblem, x::AbstractVector{T})

Evaluate the registered Jacobian of `c(x)` and write it to `J`.

`J` must have size `(prob.ncon, prob.nvar)`. Each row contains the gradient of
one scalar constraint. Throws an error when an analytical constraint Jacobian
is not registered.
"""
function eval_constraint_jacobian!(
    J::AbstractMatrix{T},
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_size(J, (prob.ncon, prob.nvar), "J")

    if !isnothing(prob.constraint_jacobian)
        for i in 1:prob.ncon
            prob.constraint_jacobian[i](view(J, i, :), x)
        end
        return J
    end

    error("Analytical constraint Jacobian is not registered for problem '$(prob.name)'.")
end

"""
    eval_constraint_jacobian(prob::MOProblem, x::AbstractVector{T})

Evaluate the registered Jacobian of `c(x)`.

The returned matrix has size `(prob.ncon, prob.nvar)` and element type `T`.
"""
function eval_constraint_jacobian(
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    return eval_constraint_jacobian!(Matrix{T}(undef, prob.ncon, prob.nvar), prob, x)
end

"""
    eval_constraint_jacobian_row!(row, prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the gradient of the `i`-th constraint and write it to `row`.
"""
function eval_constraint_jacobian_row!(
    row::AbstractVector{T},
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(row, prob.nvar, "row")

    if !isnothing(prob.constraint_jacobian)
        prob.constraint_jacobian[i](row, x)
        return row
    end

    error("Analytical constraint Jacobian is not registered for problem '$(prob.name)'.")
end

"""
    eval_constraint_jacobian_row(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the gradient of the `i`-th constraint.
"""
function eval_constraint_jacobian_row(
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    return eval_constraint_jacobian_row!(Vector{T}(undef, prob.nvar), prob, x, i)
end

"""
    eval_hessian_row!(H, prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the Hessian matrix of the `i`-th objective at `x` and write the result
to `H`.

`x` must have length `prob.nvar`, `H` must have size
`(prob.nvar, prob.nvar)`, and `i` must be between `1` and `prob.nobj`.

Returns `H`. Throws an error if `prob` has no registered analytical Hessian.
"""
function eval_hessian_row!(
    H::AbstractMatrix{T},
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_size(H, (prob.nvar, prob.nvar), "H")

    if !isnothing(prob.hessian)
        prob.hessian[i](H, x)
        return H
    end

    error("Analytical Hessian is not registered for problem '$(prob.name)'.")
end

"""
    eval_hessian_row(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the Hessian matrix of the `i`-th objective at `x`.

`x` must have length `prob.nvar`, and `i` must be between `1` and `prob.nobj`.
The returned matrix has size `(prob.nvar, prob.nvar)` and element type `T`.

Throws an error if `prob` has no registered analytical Hessian.
"""
function eval_hessian_row(prob::MOProblem, x::AbstractVector{T}, i::Int) where {T <: AbstractFloat}
    return eval_hessian_row!(Matrix{T}(undef, prob.nvar, prob.nvar), prob, x, i)
end

"""
    eval_hessian!(Hs, prob::MOProblem, x::AbstractVector{T})

Evaluate the Hessian matrices of all objectives at `x`.

`x` must have length `prob.nvar`, `Hs` must have length `prob.nobj`, and each
entry of `Hs` must have size `(prob.nvar, prob.nvar)`.

Returns `Hs`. Throws an error if `prob` has no registered analytical Hessian.
"""
function eval_hessian!(
    Hs::AbstractVector{<:AbstractMatrix{T}},
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(Hs, prob.nobj, "Hs")
    for i in 1:prob.nobj
        _check_output_size(Hs[i], (prob.nvar, prob.nvar), "Hs[$i]")
    end

    if !isnothing(prob.hessian)
        for i in 1:prob.nobj
            prob.hessian[i](Hs[i], x)
        end
        return Hs
    end

    error("Analytical Hessian is not registered for problem '$(prob.name)'.")
end

"""
    eval_hessian(prob::MOProblem, x::AbstractVector{T})

Evaluate the Hessian matrices of all objectives at `x`.

`x` must have length `prob.nvar`. The returned vector has length `prob.nobj`;
each entry is a `(prob.nvar, prob.nvar)` matrix with element type `T`.

Throws an error if `prob` has no registered analytical Hessian.
"""
function eval_hessian(prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    Hs = [Matrix{T}(undef, prob.nvar, prob.nvar) for _ in 1:prob.nobj]
    return eval_hessian!(Hs, prob, x)
end

"""
    eval_constraint_hessian_row!(H, prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the registered Hessian of the `i`-th constraint and write it to `H`.
"""
function eval_constraint_hessian_row!(
    H::AbstractMatrix{T},
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_size(H, (prob.nvar, prob.nvar), "H")

    if !isnothing(prob.constraint_hessian)
        prob.constraint_hessian[i](H, x)
        return H
    end

    error("Analytical constraint Hessian is not registered for problem '$(prob.name)'.")
end

"""
    eval_constraint_hessian_row(prob::MOProblem, x::AbstractVector{T}, i::Int)

Evaluate the registered Hessian of the `i`-th constraint.
"""
function eval_constraint_hessian_row(
    prob::MOProblem,
    x::AbstractVector{T},
    i::Int
) where {T <: AbstractFloat}
    return eval_constraint_hessian_row!(Matrix{T}(undef, prob.nvar, prob.nvar), prob, x, i)
end

"""
    eval_constraint_hessian!(Hs, prob::MOProblem, x::AbstractVector{T})

Evaluate all registered constraint Hessians and write them to `Hs`.
"""
function eval_constraint_hessian!(
    Hs::AbstractVector{<:AbstractMatrix{T}},
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    _check_dimension(prob, x)
    _check_output_length(Hs, prob.ncon, "Hs")
    for i in 1:prob.ncon
        _check_output_size(Hs[i], (prob.nvar, prob.nvar), "Hs[$i]")
    end

    if !isnothing(prob.constraint_hessian)
        for i in 1:prob.ncon
            prob.constraint_hessian[i](Hs[i], x)
        end
        return Hs
    end

    error("Analytical constraint Hessian is not registered for problem '$(prob.name)'.")
end

"""
    eval_constraint_hessian(prob::MOProblem, x::AbstractVector{T})

Evaluate all registered constraint Hessians.

The returned vector has length `prob.ncon`; each matrix has size
`(prob.nvar, prob.nvar)` and element type `T`.
"""
function eval_constraint_hessian(
    prob::MOProblem,
    x::AbstractVector{T}
) where {T <: AbstractFloat}
    Hs = [Matrix{T}(undef, prob.nvar, prob.nvar) for _ in 1:prob.ncon]
    return eval_constraint_hessian!(Hs, prob, x)
end
