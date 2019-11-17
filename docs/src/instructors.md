## Pedagogy/Philosophy
The Jupyter notebooks and associated worksheets are based on Process Oriented Guided Inquiry Learning [POGIL](https://pogil.org/) pedagogy. Students construct knowlege by
interacting with the web-apps and by collaborating in small teams. 

## Hosting
The notebooks can be executed in the browser through binder. Binder serves a 
complete Jupyter/Julia environment in your browser. Click on the badge below to
launch it.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mdpetters/Atmospheric-Physics-Notebooks.git/master)

The binder service is free and appropriate for a few users or workshops. The service
may not be reliable for class-deployment.

The repository follows the [reproducible build specifications](https://repo2docker.readthedocs.io/en/latest/specification.html). A docker image
can be prepared using [repo2docker](https://repo2docker.readthedocs.io/en/latest/).

The docker image can be served to a large group using [jupyter-hub](https://zero-to-jupyterhub.readthedocs.io/en/latest/index.html) with Kubernetes. 
Running the Kubernetes engine for students to access the content 24/7 costs ~\$30/user and semester. Cloud hosting is needed because 

* Hosting the service in the cloud makes the notebook available on tablets, 
mobile devices, and any computer that has browser access, thus broadening the opportunities to use the apps outside of class, and for students that need to use library computers.
* Install on local machines can be tricky, especially for the notebooks that interface with atmospheric models written in other languages (e.g. python and fortran). 
* The notebook widget state can potentially be corrupted during saving and restart, 
which leads to a delay in spin-up and student frustration. The Kubernetes engine 
serves a non-persistent container image that is guaranteed to work.
* The Kubernetes engine can scale up and down with student demand.
* The cloud services are almost 100% reliable.
 
## Contributing
If you wish to use the material in your course I recommend forking the repository
and adapting the content as needed. If you do so, please share the improved content. 
Linking the repositories will help others to find the class materials.

If you have suggestions for improving the questions please email the author and/or
open the discussion in the [issues tab](https://github.com/mdpetters/Atmospheric-Physics-Notebooks/issues).

## Software
The apps are programmed using the [Julia Progamming Language](https://julialang.org/)
using the reactive prgramming paradigm. Some of the packages that are used:

* [Gadfly.jl](http://gadflyjl.org/stable/) for standard plotting
* [Interact.jl](https://juliagizmos.github.io/Interact.jl/stable/) for reactive widgets
* [Documenter.jl](https://juliadocs.github.io/Documenter.jl/stable/) for creating the documentation
* [Makie.jl](http://makie.juliaplots.org/stable/) for GPU plotting and movie animations
* [PyCall;.jl](https://github.com/JuliaPy/PyCall.jl) for calling Python-based parcel model
* [IJulia.jl](https://github.com/JuliaLang/IJulia.jl) for Jupyter Integration
* [WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) for rendering Apps

The key packages key pacakages that create the content are Gadfly and Interact. 
Note that Gadfly is based on the [Grammar of Graphics](https://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448). It is built on top of [Compose.jl](https://giovineitalia.github.io/Compose.jl/stable/), declerative vector graphics written in pure Juia. 

There are pros and cons of this approach. The main pros are

The pros for Gadfly.jl are
* The grammar of graphics creates a paradigm for easy to decode and clear visualizations. 
This is critical for learning, as reading complex graphs and reasoning about the content 
is part of the learning objectives.
* The visual appeal and rendering is of high quality (e.g. compared to default matplotlib). 

The main cons are 
* The rendering can be slow.
* Grammar of graphics code can be verbose.
* The syntax is very different than most other scientific plotting packages (e.g. MATLAB, python, IDL).

Interact works with most of the available plotting packages (e.g. [Plots.jl](http://docs.juliaplots.org/latest/), [GR.jl](https://github.com/jheinen/GR.jl)). In fact, the
first version of these notebooks used Plots.jl. Note that [Makie.jl](http://makie.juliaplots.org/stable/) is very promising but requires cloud-based GPU resources to be deployed effectively in this context.
