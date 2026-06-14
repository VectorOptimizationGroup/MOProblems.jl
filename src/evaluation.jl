"""
    _domain_error(prob::MOProblem, x::AbstractVector, kind::String, err)

Build a `DomainViolationError` for numerical failures raised while evaluating
`prob` at `x`.

This helper keeps the public evaluation methods consistent when wrapping
mathematical-domain failures.
"""
function _domain_error(prob::MOProblem, x::AbstractVector, kind::String, err)
    return DomainViolationError(
        string(typeof(prob)),
        collect(x),
        kind,
        "Mathematical error during evaluation: $(string(err))"
    )
end

"""
    _is_domain_error(err) -> Bool

Return `true` when `err` is treated as a numerical-domain failure by the
evaluation API.
"""
function _is_domain_error(err)
    return err isa DomainError ||
           err isa InexactError ||
           err isa OverflowError ||
           err isa UndefVarError ||
           err isa BoundsError
end

"""
    _check_dimension(prob::MOProblem, x::AbstractVector)

Validate that `x` has length `prob.nvar`.
"""
function _check_dimension(prob::MOProblem, x::AbstractVector)
    @assert length(x) == prob.nvar "Length of x ($(length(x))) does not match the number of variables ($(prob.nvar))"
    return nothing
end

"""
    _check_objective_index(prob::MOProblem, i::Int)

Validate that `i` is a valid objective index for `prob`.
"""
function _check_objective_index(prob::MOProblem, i::Int)
    @assert 1 <= i <= prob.nobj "Objective index ($i) must be between 1 and $(prob.nobj)"
    return nothing
end

"""
    _check_output_length(y::AbstractVector, expected::Int, name::String)

Validate that output vector `y` has the expected length.
"""
function _check_output_length(y::AbstractVector, expected::Int, name::String)
    @assert length(y) == expected "Length of $name ($(length(y))) must be equal to $expected"
    return nothing
end

"""
    _check_output_size(A::AbstractMatrix, expected::Tuple{Int, Int}, name::String)

Validate that output matrix `A` has the expected size.
"""
function _check_output_size(A::AbstractMatrix, expected::Tuple{Int, Int}, name::String)
    @assert size(A) == expected "Size of $name ($(size(A))) must be equal to $expected"
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
    try
        _check_dimension(prob, x)
        _check_output_length(y, prob.nobj, "y")
        for i in 1:prob.nobj
            y[i] = prob.f[i](x)
        end
        return y
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "function_evaluation", err))
        rethrow(err)
    end
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
    try
        _check_objective_index(prob, i)
        _check_dimension(prob, x)
        return T(prob.f[i](x))
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "function_evaluation", err))
        rethrow(err)
    end
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
    try
        _check_dimension(prob, x)
        _check_output_size(J, (prob.nobj, prob.nvar), "J")

        if prob.has_jacobian
            if !isnothing(prob.jacobian)
                J .= prob.jacobian(x)
                return J
            elseif !isempty(prob.jacobian_by_row)
                for i in 1:prob.nobj
                    J[i, :] = prob.jacobian_by_row[i](x)
                end
                return J
            end
        end

        error("Analytical Jacobian is not registered for problem '$(prob.name)'.")
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "jacobian_evaluation", err))
        rethrow(err)
    end
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
    try
        _check_objective_index(prob, i)
        _check_dimension(prob, x)
        _check_output_length(row, prob.nvar, "row")

        if prob.has_jacobian
            if !isempty(prob.jacobian_by_row)
                row .= prob.jacobian_by_row[i](x)
                return row
            elseif !isnothing(prob.jacobian)
                row .= view(prob.jacobian(x), i, :)
                return row
            end
        end

        error("Analytical Jacobian is not registered for problem '$(prob.name)'.")
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "jacobian_evaluation", err))
        rethrow(err)
    end
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
    try
        _check_objective_index(prob, i)
        _check_dimension(prob, x)
        _check_output_size(H, (prob.nvar, prob.nvar), "H")

        if prob.has_hessian
            if !isempty(prob.hessian_by_row)
                H .= prob.hessian_by_row[i](x)
                return H
            elseif !isnothing(prob.hessian)
                H .= prob.hessian(x)[i]
                return H
            end
        end

        error("Analytical Hessian is not registered for problem '$(prob.name)'.")
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "hessian_evaluation", err))
        rethrow(err)
    end
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
    eval_hessian(prob::MOProblem, x::AbstractVector{T})

Evaluate the Hessian matrices of all objectives at `x`.

`x` must have length `prob.nvar`. The returned vector has length `prob.nobj`;
each entry is a `(prob.nvar, prob.nvar)` matrix with element type `T`.

Throws an error if `prob` has no registered analytical Hessian.
"""
function eval_hessian(prob::MOProblem, x::AbstractVector{T}) where {T <: AbstractFloat}
    try
        _check_dimension(prob, x)

        if prob.has_hessian
            Hs = [Matrix{T}(undef, prob.nvar, prob.nvar) for _ in 1:prob.nobj]
            if !isnothing(prob.hessian)
                Hs_raw = prob.hessian(x)
                for i in 1:prob.nobj
                    Hs[i] .= Hs_raw[i]
                end
                return Hs
            elseif !isempty(prob.hessian_by_row)
                for i in 1:prob.nobj
                    Hs[i] .= prob.hessian_by_row[i](x)
                end
                return Hs
            end
        end

        error("Analytical Hessian is not registered for problem '$(prob.name)'.")
    catch err
        _is_domain_error(err) && throw(_domain_error(prob, x, "hessian_evaluation", err))
        rethrow(err)
    end
end
