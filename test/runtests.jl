using Test
using Random
using LinearAlgebra

using MultiObjectiveProblems

# `MO_FAST=1` tests representative dimensions; `MO_FAST=0` tests the full set.

include(joinpath(@__DIR__, "TestUtils.jl"))

include(joinpath(@__DIR__, "contracts", "problem_definitions.jl"))
include(joinpath(@__DIR__, "interface", "numeric_type_contract.jl"))
include(joinpath(@__DIR__, "jacobians", "analytic_vs_fd.jl"))
include(joinpath(@__DIR__, "hessians", "H_analytic_vs_fd.jl"))
include(joinpath(@__DIR__, "constraints", "evaluation.jl"))
include(joinpath(@__DIR__, "catalog", "listings.jl"))
include(joinpath(@__DIR__, "dimensions", "variable_dimension.jl"))
include(joinpath(@__DIR__, "references", "source_values.jl"))
