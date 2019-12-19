Install the latest release of julia from [https://julialang.org/downloads/](https://julialang.org/downloads/). 

Once installed start the julia REPL (Read-Eval-Print-Loop)

```
              _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.3.0 (2019-11-26)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

At the prompt type 

```
julia> ]
```
to start the package manager. Then, add the following julia packages:

```julia
pkg> add CSV Colors Compose Conda Contour DataFrames DifferentialEquations Distributions Documenter Gadfly  IJulia Interact Interpolations LsqFit NumericIO ParameterizedFunctions Pkg PyCall Roots SpecialFunctions WebIO
```

Next, install the Jupyter notebook server
```julia
julia> using IJulia
julia> notebook()
```
Next, exit the notbook and exit out of the julia REPL session. Restart the REPL.
and install the WebIO Jupyter extension:

```julia
julia> using WebIO
julia> WebIO.install_jupyter_nbextension()
```
Finally, download the ZIP'ed notebooks from GitHub: [Atmospheric-Physics-Notebooks](https://github.com/mdpetters/Atmospheric-Physics-Notebooks)

![alt text](figures/notebook_zip.png)

Extract the ZIP file to location of your choice (e.g. ```Documents```).

```julia
julia> cd("Path/To/Atmospheric-Physics-Notebooks")
julia> ]
pkg> dev deps/AtmosphericThermodynamics/
pkg> dev deps/DifferentialMobilityAnalyzers/
pkg> add Calculus LambertW LinearAlgebra Random SpecialFunctions StatsBase
```

Start the notebook server:

```julia
julia> using IJulia
julia> notebook()
```

Navigate to the extracted folder and open any of the notebooks, i.e. files with with the ```.ipynb``` extension.

![alt text](figures/Desktop.png)