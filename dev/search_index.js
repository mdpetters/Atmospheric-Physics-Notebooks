var documenterSearchIndex = {"docs":
[{"location":"#Atmospheric-Physics-1","page":"Introduction","title":"Atmospheric Physics","text":"","category":"section"},{"location":"#","page":"Introduction","title":"Introduction","text":"Author: Markus Petters","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"This repository contains Jupyter notebooks used to supplement instruction in MEA-412: Atmospheric Physics (Course Catalog) taught in the Department of Marine, Earth, and Atmospheric Sciences at NC State University. ","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"The notebooks can be executed in the browser through binder. Binder serves a  complete Jupyter/julia environment in your browser. Click on the badge below to launch it.","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"(Image: Binder)","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"Use the Jupyter file-manager to navigate to a notebook. For example, the directory src/Warm Cloud Formation as shown below.","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"(Image: alt text)","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"Start the notebook Warm Cloud Formation.ipynb and \"Run All Below\".","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"(Image: alt text)","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"During the first execution of the notebook julia compiles some code.  Time of first execution is ~2 min. Once a cell has been processed a  number appears in parenthesis, e.g. In[1]","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"(Image: alt text)","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"The notebook is now ready. You can interact with the graphs using the  widgets provided with each element. It is not necessary to execute  the cells again. However, the notebook is a complete programming environment.  Second execution of the code is fast. Indivual cells can be executed using  CTRL-ENTER.","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"Binder watches for activity. After ~10 min of inactivity, the container is destroyed.  Once the container is destroyed the computing environment is closed and the buttons become unresponsive. ","category":"page"},{"location":"#","page":"Introduction","title":"Introduction","text":"The notebooks can also be executed locally as described in Local Installation.  ","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Install the Long-term support (LTS) release of julia from https://julialang.org/downloads/. ","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Once installed start the julia REPL (Read-Eval-Print-Loop)","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"              _\n   _       _ _(_)_     |  Documentation: https://docs.julialang.org\n  (_)     | (_) (_)    |\n   _ _   _| |_  __ _   |  Type \"?\" for help, \"]?\" for Pkg help.\n  | | | | | | |/ _` |  |\n  | | |_| | | | (_| |  |  Version 1.0.5 (2019-09-09)\n _/ |\\__'_|_|_|\\__'_|  |  Official https://julialang.org/ release\n|__/                   |\n\njulia>","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"At the prompt type ","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> ]","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"to start the package manager. Then, add the following julia packages:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"pkg> add Gadfly Interact WebIO IJulia","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Next, install the Jupyter notebook server","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using IJulia\njulia> notebook()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Next, exit the notbook and exit out of the julia REPL session. Restart the REPL. and install the WebIO Jupyter extension:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using WebIO\njulia> WebIO.install_jupyter_nbextension()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Finally, download the ZIP'ed notebooks from GitHub: MEA-412-Notebooks","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"(Image: alt text)","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Extract the ZIP file to location of your choice (e.g. Desktop).  Start the notebook server:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using IJulia\njulia> notebook()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Navigate to the extracted folder and open any of the notebooks.","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"(Image: alt text)","category":"page"},{"location":"license/#Software-1","page":"License","title":"Software","text":"","category":"section"},{"location":"license/#","page":"License","title":"License","text":"Software provided within this repository is copyrighted by the author of the repository and licensed under the GNU General Public License.  Software refers to all scripts that create the figures and apps in the Jupyter notebooks.","category":"page"},{"location":"license/#","page":"License","title":"License","text":"Software from other sources (e.g. the parcel model) is cited when used and licensed as specified by the author(s) of said software.","category":"page"},{"location":"license/#Images-and-Notebooks-1","page":"License","title":"Images and Notebooks","text":"","category":"section"},{"location":"license/#","page":"License","title":"License","text":"The content in the Jupyter notebooks and images created by the author of the repository are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0) Human Readable Format or  Full Text. Images taken from other sources are cited and licensed as specified by the originator.","category":"page"},{"location":"instructors/#Pedagogy/Philosophy-1","page":"For Instructors","title":"Pedagogy/Philosophy","text":"","category":"section"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The Jupyter notebooks and associated worksheets are based on Process Oriented Guided Inquiry Learning POGIL pedagogy. Students construct knowlege by interacting with the web-apps and by collaborating in small teams. ","category":"page"},{"location":"instructors/#Hosting-1","page":"For Instructors","title":"Hosting","text":"","category":"section"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The notebooks can be executed in the browser through binder. Binder serves a complete Jupyter;Julia environment in your browser. Click on the badge below to launch it.","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"(Image: Binder)","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The binder service is free and appropriate for a few users or workshops. The service may not be reliable for class-deployment.","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The repository follows the reproducible build specifications. A docker image can be prepared using repo2docker.","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The docker image can be served to a large group using jupyter-hub with Kubernetes. Running the Kubernetes engine for students to access the content 24/7 costs ~$30/user and semester. Cloud hosting is needed because ","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"Hosting the service in the cloud makes the notebook available on tablets, mobile devices, and any computer that has browser access, thus broadening the opportunities to use the apps outside of class, and for students that need to use library computers.\nInstall on local machines can be tricky, especially for the notebooks that interface with atmospheric models written in other languages (e.g. python and fortran). \nThe notebook widget state can potentially be corrupted during saving and restart,  which leads to a delay in spin-up and student frustration. The Kubernetes engine serves a non-persistent container image that is guaranteed to work.\nThe Kubernetes engine can scale up and down with student demand.\nThe cloud services are almost 100% reliable.","category":"page"},{"location":"instructors/#Contributing-1","page":"For Instructors","title":"Contributing","text":"","category":"section"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"If you wish to use the material in your course I recommend forking the repository and adapting the content as needed. If you do so, please share the improved content. Linking the repositories will help others to find the class materials.","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"If you have suggestions for improving the questions please email the author and/or open the discussion in the issues tab.","category":"page"},{"location":"instructors/#Software-1","page":"For Instructors","title":"Software","text":"","category":"section"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The apps are programmed using the Julia Progamming Language using the reactive prgramming paradigm. Some of the packages that are used:","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"Gadfly.jl for standard plotting\nInteract.jl for reactive widgets\nDocumenter.jl for creating the documentation\nMakie.jl for GPU plotting and movie animations\nPyCall;.jl for calling Python-based parcel model\nIJulia.jl for Jupyter Integration\nWebIO.jl for rendering Apps","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The key packages key pacakages that create the content are Gadfly and Interact.  Note that Gadfly is based on the Grammar of Graphics. It is built on top of Compose.jl, declerative vector graphics written in pure Juia. ","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"There are pros and cons of this approach. The pros for Gadfly.jl are","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The grammar of graphics creates a paradigm for easy to decode and clear visualizations. This is critical for learning, as reading complex graphs and reasoning about the content is part of the learning objectives.\nThe visual appeal and rendering is of high quality (e.g. compared to default matplotlib). ","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The main cons are ","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"The rendering can be slow.\nGrammar of graphics code can be verbose.\nThe syntax is very different than most other scientific plotting packages (e.g. MATLAB, python, IDL).","category":"page"},{"location":"instructors/#","page":"For Instructors","title":"For Instructors","text":"Interact works with most of the available plotting packages (e.g. Plots.jl, GR.jl). In fact, the first version of these notebooks used Plots.jl. Note that Makie.jl is very promising but requires cloud-based GPU resources to be deployed effectively in this context.","category":"page"}]
}
