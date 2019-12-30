using Documenter

makedocs(
  sitename = "Atmospheric Physics",
  authors = "Markus Petters",
  pages = [
   "Introduction" => "index.md",
   "Content" => "content.md",
   "Installation" => "installation.md",
   "For Instructors" => "instructors.md",
   "License" => "license.md"
    ]
)

deploydocs(
    repo = "github.com/mdpetters/Atmospheric-Physics-Notebooks.git"
)
