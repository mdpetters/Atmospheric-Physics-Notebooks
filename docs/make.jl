using Documenter

makedocs(
  sitename = "Atmospheric Physics",
  authors = "Markus Petters",
  pages = [
    "Home" => "index.md",
    "Local Installation" => "installation.md",
    "License" => "license.md" 
    ]
)

deploydocs(
    repo = "github.com/mdpetters/MEA-412-Notebooks.git"
)
