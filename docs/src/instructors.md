## Overview
The materials are designed for undergraduate students who have completed an introductory class in <i> Atmospheric Science </i> and <i> Atmospheric Thermodynamics</i>. However, the modules are also suitable to supplement graduate student instruction and also be used by professionals who seek simple introductory materials on the topic.

The modules are designed for students to construct knowledge by interacting with the web-apps. They can do so by working alone or collaborating in small teams. The modules are interconnected and somewhat build on each other. However, the modules can also be used independently as assignments for special topics in graduate classes, which include a more mathematical treatment of the subject.

There is ~5 min spin-up time to initialize a module, which includes login to the server and first execution of all apps. Students start the appropriate module at the beginning of class. The time can be used to conduct standard class business, hold a short review, or start a mini lecture. Due to this time overhead lecture periods of 75 min are preferred.

When used in a class setting, some of the individual apps are introduced with mini lectures. Students can work alone or in groups interacting with the individual apps in the module on prompt. This is followed by a whole-class discussion, soliciting responsed from each group, clearing up muddy points, and summarizing the main takeaway messages. Some of the exercises are specifically designed as homework, e.g. the programming exercises. Others can be assigned as either in-class or homework assignment, depdending on the class flow. 

Modules are grouped by topic and <b> not </b> tailored to be completed within a single class period.

## Notable Influences
The module content and design have been influenced by

* Process Oriented Guided Inquiry Learning [POGIL](https://pogil.org/) pedagogy. Although the modules do not strictly apply all POGIL components, they embrace the idea that knowledge is constructed by the learner by actively manipulating, concepts, data and equations using peer instruction. 
* Rogers, R.R. and Yau, M.K.: [A Short Course in Cloud Physics](https://www.amazon.com/s?k=A+Short+Course+in+Cloud+Physics&i=stripbooks-intl-ship&ref=nb_sb_noss). Especially the collision/coalescence chapter.
* Bjorn Stevens: [Twelve Lectures in Cloud Physics](https://www.mpimet.mpg.de/fileadmin/staff/stevensbjorn/teaching/skript-5.pdf). Especially the scripts' minimalist approach distilling the topics to its essentials.
* Hinds, W. C.: [Aerosol Technology](https://www.amazon.com/Aerosol-Technology-Properties-Measurement-Particles/dp/0471194107).
* [Glossary of Meteorology](http://glossary.ametsoc.org/wiki/Main_Page). Used for definitions of key concepts.
* The authors' preferences related to topic selection and preference to include examples with real and imperfect data. 

## Hosting
The notebooks can be executed in the browser through binder. Binder serves a complete Jupyter/Julia environment in your browser. Click on the badge below to launch it.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mdpetters/Atmospheric-Physics-Notebooks.git/master)

The binder service is free and appropriate for a few users or workshops. The service may not be reliable for class-deployment.

The repository follows the [reproducible build specifications](https://repo2docker.readthedocs.io/en/latest/specification.html). A docker image can be prepared using [repo2docker](https://repo2docker.readthedocs.io/en/latest/).

The docker image can be served to a large group using [jupyter-hub](https://zero-to-jupyterhub.readthedocs.io/en/latest/index.html) with Kubernetes. Running the Kubernetes engine for students to access the content 24/7 costs ~\$30/user and semester. Cloud hosting is needed because 

* Hosting the service in the cloud makes the notebook available on tablets, mobile devices, and any computer that has browser access, thus broadening the opportunities to use the apps outside of class, and for students that need to use library computers.
* Install on local machines can be tricky, especially for the notebooks that interface with atmospheric models written in other languages (e.g. python and fortran). 
* The notebook widget state can potentially be corrupted during saving and restart,  which leads to a delay in spin-up and student frustration. The Kubernetes engine serves a non-persistent container image that is guaranteed to work.
* The Kubernetes engine can scale up and down with student demand.
* The cloud services are almost 100% reliable.
 
## Contributing
If you wish to use the material in your course I recommend forking the repository and adapting the content as needed. If you do so, please share the improved content. Linking the repositories will help others to find the class materials.

If you have suggestions for improving the questions please email the author and/or open the discussion in the [issues tab](https://github.com/mdpetters/Atmospheric-Physics-Notebooks/issues).

## Software
The apps are programmed using the [Julia Progamming Language](https://julialang.org/) using the reactive prgramming paradigm. Some of the key packages that are used:

* [Gadfly.jl](http://gadflyjl.org/stable/) for standard plotting
* [Compose.jl](https://giovineitalia.github.io/Compose.jl/latest/) for vector graphics
* [Interact.jl](https://juliagizmos.github.io/Interact.jl/stable/) for reactive widgets
* [Documenter.jl](https://juliadocs.github.io/Documenter.jl/stable/) for creating the documentation
* [Makie.jl](http://makie.juliaplots.org/stable/) for GPU plotting and movie animations
* [PyCall.jl](https://github.com/JuliaPy/PyCall.jl) for calling Python-based parcel model
* [IJulia.jl](https://github.com/JuliaLang/IJulia.jl) for Jupyter integration
* [WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) for rendering Apps

The key packages key pacakages that create the content are Gadfly and Interact.  Note that Gadfly is based on the [Grammar of Graphics](https://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448). It is built on top of [Compose.jl](https://giovineitalia.github.io/Compose.jl/stable/), declerative vector graphics written in pure Juia. 

There are pros and cons of this approach. The pros for Gadfly.jl are

* The grammar of graphics creates a paradigm for easy to decode and clear visualizations. This is critical for learning, as reading complex graphs and reasoning about the content is part of the learning objectives.
* The visual appeal and rendering is of high quality (e.g. compared to default matplotlib). 

The main cons are 
* The rendering can be slow(er).
* Grammar of graphics code can be verbose.
* The syntax is very different than most other scientific plotting packages (e.g. MATLAB, python, IDL).

Interact.jl works with most of the available plotting packages (e.g. [Plots.jl](http://docs.juliaplots.org/latest/), [GR.jl](https://github.com/jheinen/GR.jl)). In fact, the
first version of these notebooks used Plots.jl. Note that [Makie.jl](http://makie.juliaplots.org/stable/) is very promising but requires cloud-based GPU resources to be deployed effectively in this context.