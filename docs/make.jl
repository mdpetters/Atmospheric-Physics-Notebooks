using Documenter

makedocs(
  sitename = "MEA-412 Atmospheric Physics",
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
    repo = "github.com/mdpetters/MEA-412-Notebooks.git"
)
