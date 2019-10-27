push!(LOAD_PATH, "../src/")
using Documenter, LabjackU6Library


makedocs(
  sitename = "LabjackU6Library.jl",
  authors = "Markus Petters",
  pages = [
    "Home" => "index.md",
    "Installation" => "installation.md",
    "API" => [
        "functions.md",
        "structures.md"
    ],
    "License" => "licence.md"
  ]

)

deploydocs(
    repo = "github.com/mdpetters/LabjackU6Library.jl.git"
)
