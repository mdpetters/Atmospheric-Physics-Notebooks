## DifferentialMobilityAnalyzers.jl
[![travis badge][travis_badge]][travis_url]
[![appveyor badge][appveyor_badge]][appveyor_url]
[![codecov badge][codecov_badge]][codecov_url]
[![][docs-stable-img]](docs/DOCUMENTATION.md)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2652893.svg)](https://doi.org/10.5281/zenodo.2652893)

This package implements the Julia DMA language. The language is a tool to facilitate interpretation of data from aerosol differential mobility analyzers.

<b> Note that this package has been updated to be compatible with the Julia v1 series and later. To see the code directly associated with the paper (compatible with Julia v0.6), please switch to version 1.0.0 of the package and/or load the zenodo virtual machine associated with that version. The update mostly fixed Julia language deprecations. For a detailed list of changes with the current version please read the [News](NEWS.md). </b>

## Documentation
[Link to detailed documentation](docs/DOCUMENTATION.md)

## Installation & Quickstart
The package  <b> DifferentialMobiliyAnalyzers </b> can be installed from the Julia package prompt with
```julia
pkg> add https://github.com/mdpetters/DifferentialMobilityAnalyzers.jl.git
pkg> add Calculus DataFrames Distributions Glob IJulia Interpolations LambertW LinearAlgebra LsqFit NetCDF ORCA PlotlyJS Plots Printf ProgressMeter Random SpecialFunctions StatsBase
```
This installs the package and any missing dependencies. (Patience required for fresh install).
```julia
julia> using IJulia
julia> notebook(detached = true)
```
This starts the notebook server. Then load any of the notebooks in the docs/ folder.

Quickstart: The Julia DMA language is documented in a journal manuscript and 12 Supplementary Jupyter Notebooks. The links open the notebooks in viewer mode via NBViewer. Virtual machines with working copies of all software components can be downloaded from [zenodo](https://doi.org/10.5281/zenodo.2652893). Machines are available for Version 1.0.0 and 2.0 of the package. Instructions for setting up the machine are in the Supporting Information.

The Julia DMA Language: [Manuscript](docs/Manuscript.pdf) and [Supporting Information](docs/SI.pdf)<br>
[Notebook S1. Differential Mobility Analyzer](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S01.%20Differential%20Mobility%20Analyzer.ipynb) <br>
[Notebook S2. Fredholm Integral Equation](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S02.%20Fredholm%20Integral%20Equation.ipynb) <br>
[Notebook S3. Size Distribution Arithmetic](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S03.%20Size%20Distribution%20Arithmetic.ipynb) <br>
[Notebook S4. Single Mobility Classification](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S04.%20Single%20Mobility%20Classification.ipynb) <br>
[Notebook S5. Size Distribution Inversion Using Regularization](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S05.%20Size%20Distribution%20Inversion%20Using%20Regularization.ipynb) <br>
[Notebook S6. Size Distribution Inversion of Ambient Data](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S06.%20Size%20Distribution%20Inversion%20of%20Ambient%20Data.ipynb) <br>
[Notebook S7. Size resolved CCN measurements](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S07.%20Size%20resolved%20CCN%20measurements.ipynb) <br>
[Notebook S8. Hygroscopicity Tandem DMA](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S08.%20Hygroscopicity%20Tandem%20DMA.ipynb) <br>
[Notebook S9. Volatility Tandem DMA](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S09.%20Volatility%20Tandem%20DMA.ipynb) <br>
[Notebook S10. Dimer Coagulation and Isolation](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S10.%20Dimer%20Coagulation%20and%20Isolation.ipynb) <br>
[Notebook S11. PartMC Simulations](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S11.%20PartMC%20Simulations.ipynb)<br>
[Notebook S12. FORTRAN API](https://nbviewer.jupyter.org/github/mdpetters/DifferentialMobilityAnalyzers.jl/blob/master/docs/Notebook%20S12.%20FORTRAN%20API.ipynb) <br>
[Link to Virtual Machine](https://doi.org/10.5281/zenodo.2652893)<br>

## Contribute
Contributions including notebooks for classroom instruction, homework assignments, interesting DMA configurations, new inversion schemes, and improved or new functionalities of the language are welcome.

## Citations
This work was supported by the United States Department of Energy, Office of Science, Biological and Environment Research, Grant number DE-SC0018265.

Petters, M.D. (2018) <i> A language to simplify computation of differential mobility analyzer response functions </i> Aerosol Science & Technology, 52 (12), 1437-1451, https://doi.org/10.1080/02786826.2018.1530724.

Petters, M.D. (2019, April 27) <i> Virtual Machine containing Software for "A language to simplify computation of differential mobility analyzer response functions"</i> (Version 2.0), [Software], Zenodo, https://doi.org/10.5281/zenodo.2652893.

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg

[travis_badge]: https://travis-ci.org/mdpetters/DifferentialMobilityAnalyzers.jl.svg?branch=master
[travis_url]: https://travis-ci.org/mdpetters/DifferentialMobilityAnalyzers.jl

[appveyor_badge]: https://ci.appveyor.com/api/projects/status/github/mdpetters/DifferentialMobilityAnalyzers.jl?svg=true&branch=master

[appveyor_url]: https://ci.appveyor.com/project/mdpetters/differentialmobilityanalyzers-jl

[codecov_badge]: http://codecov.io/github/mdpetters/DifferentialMobilityAnalyzers.jl/coverage.svg?branch=master
[codecov_url]: http://codecov.io/github/mdpetters/DifferentialMobilityAnalyzers.jl?branch=master
