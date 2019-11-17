using Documenter

makedocs(
  sitename = "Atmospheric Physics",
  authors = "Markus Petters",
  pages = [
   "Introduction" => "index.md",
   "Local Installation" => "installation.md",
   "License" => "license.md",
   "Instructors" => "instructors.md"
    ]
)

deploydocs(
    repo = "github.com/mdpetters/Atmospheric-Physics-Notebooks.git"
)
