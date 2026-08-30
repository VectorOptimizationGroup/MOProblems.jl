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
        "Getting Started" => [
            "Installation" => "installation.md",
            "Quick Start" => "quickstart.md",
        ],
        "Guides" => [
            "Evaluation and Derivatives" => "guides/evaluation.md",
            "Catalog and Metadata" => "guides/catalog.md",
        ],
        "Problem Families" => [
            "Overview" => "problems/index.md",
            "AAS" => "problems/aas.md",
            "AP" => "problems/ap.md",
            "BK" => "problems/bk.md",
            "DD" => "problems/dd.md",
            "DGO" => "problems/dgo.md",
            "DTLZ" => "problems/dtlz.md",
            "FA" => "problems/fa.md",
            "Far" => "problems/far.md",
            "FDS" => "problems/fds.md",
            "FF" => "problems/ff.md",
            "Hil" => "problems/hil.md",
            "IKK" => "problems/ikk.md",
            "IM" => "problems/im.md",
            "JOS" => "problems/jos.md",
            "KW" => "problems/kw.md",
            "LE" => "problems/le.md",
            "Lov" => "problems/lov.md",
            "LTDZ" => "problems/ltdz.md",
            "MGH" => "problems/mgh.md",
            "MHHM" => "problems/mhhm.md",
            "MLF" => "problems/mlf.md",
            "MMR" => "problems/mmr.md",
            "PNR" => "problems/pnr.md",
            "QV" => "problems/qv.md",
            "SD" => "problems/sd.md",
            "SK" => "problems/sk.md",
            "SLCDT" => "problems/slcdt.md",
            "SP" => "problems/sp.md",
        ],
        "API Reference" => "api.md",
        "References" => "references.md",
    ],
)

deploydocs(
    repo = "github.com/VectorOptimizationGroup/MOProblems.jl.git",
    devbranch = "main",
)
