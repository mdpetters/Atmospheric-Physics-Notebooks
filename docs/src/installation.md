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

to start the package manager. Then Install the julia package using the add command

```
pkg> add https://github.com/mdpetters/MEA-412-Notebooks.git
```

Next, add the following julia packages:
```julia
pkg> add Gadfly Interact WebIO IJulia
```

Next, install the WebIO Jupyter extension:
```julia
julia> using WebIO
julia> WebIO.install_jupyter_nbextension()
```

Finally, start the Jupyter notebook server
```julia
julia> using IJulia
julia> notebook()
```