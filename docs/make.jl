using Documenter
using DocumenterCitations
using MOProblems

bib = CitationBibliography(
    joinpath(@__DIR__, "src", "refs.bib");
    style = :numeric,
)

makedocs(
    sitename = "MOProblems.jl",
    modules = [MOProblems],
    plugins = [bib],
    checkdocs = :none,
    format = Documenter.HTML(
        prettyurls = true,
        edit_link = nothing,
    ),
    pages = [
        "Home" => "index.md",
        "Quick Start" => "quickstart.md",
        "Problem Families" => [
            "Overview" => "problems/index.md",
            "AAS" => "problems/aas.md",
            "AP" => "problems/ap.md",
            "BK" => "problems/bk.md",
            "DD" => "problems/dd.md",
            "DTLZ" => "problems/dtlz.md",
        ],
        "API Reference" => "api.md",
        "References" => "references.md",
    ],
)

deploydocs(
    repo = "github.com/VectorOptimizationGroup/MOProblems.jl.git",
    devbranch = "main",
)
