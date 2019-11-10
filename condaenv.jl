using Pkg, Conda

ENV["PYTHON"] = ""
Conda.add("numba"; channel="conda-forge")
Conda.add("future"; channel="conda-forge")
Conda.add("pandas"; channel="conda-forge")
Conda.add("assimulo"; channel="conda-forge")
