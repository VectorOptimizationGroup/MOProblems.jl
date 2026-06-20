FDS_meta = ProblemMeta(
    dimension = VariableNvar(5, 3),
    name = "FDS",               # Official problem name
    has_bounds = true,           # Box constraints present
    has_jacobian = true,         # Analytical Jacobian available
)
