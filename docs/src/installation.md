Install the Long-term support (LTS) release of julia from [https://julialang.org/downloads/](https://julialang.org/downloads/). 

Once installed start the julia REPL (Read-Eval-Print-Loop)

```
              _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.0.5 (2019-09-09)
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
pkg> add Gadfly Interact WebIO IJulia
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
Finally, download the ZIP'ed notebooks from GitHub: [MEA-412-Notebooks](https://github.com/mdpetters/MEA-412-Notebooks)

![alt text](figures/notebook_zip.png)

Extract the ZIP file to location of your choice (e.g. ```Desktop```). 
Start the notebook server:

```julia
julia> using IJulia
julia> notebook()
```

Navigate to the extracted folder and open any of the notebooks.

![alt text](figures/Desktop.png)