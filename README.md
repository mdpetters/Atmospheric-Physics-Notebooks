# Atmospheric-Physics-Notebooks

*Applets for students to playfully interact with physical relationships and
atmospheric models in an inquiry-based course on Atmospheric Physics.*

| **Documentation**                                                               | **Docker Image**                                                                                | **References** |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------:|
| [![Link to Documentation](https://img.shields.io/badge/Documentation-v2008-blue)](https://mdpetters.github.io/Atmospheric-Physics-Notebooks/dev/) | [![Docker](https://img.shields.io/docker/v/mdpetters/atmospheric-physics-notebooks?label=Docker)](https://hub.docker.com/r/mdpetters/atmospheric-physics-notebooks/tags) | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3977570.svg)](https://doi.org/10.5281/zenodo.3977570) |

## Installation

Users that want to play with notebooks and are unfamilliar with the Julia language are **strongly advised** to start with the Docker version. It simplifies the installation due to a significant number of dependencies needed for native installs. It also addresses just-in-time (JIT) compilation lag. (The first time you run a block of code in Julia it will be slow. The second time it will be fast. The Docker version comes with an optimized system image, which has a much reduced JIT lag.) The version in the Docker container/tutorial can also be used to prototype new material, which can later be incorporated into future versions.

Install the [docker engine](https://docs.docker.com/get-docker). Then run the notebooks using the following command:

```bash
docker run -it -p 8888:8888 mdpetters/atmospheric-physics-notebooks:v2008
```

This will download the container (~3GB) and exectute the container. It only needs to be downloaded once. Running the command will produce an http link **similar** to this one:

```bash
http://127.0.0.1:8888/?token=93b5e33a61654afded5f692325ac43f5c73eb6c58435196f
```

Note that the token is unique to each instance of the container. Follow the **your link** and open one of the notebooks, e.g.:

```
Module 01 - Aerosol Dynamics/Module 01 - Aerosol Dynamics.ipynb
```

Use the menu item "Cell"->"Run All Below" to execute all cells. Navigate back to the beginning and work through the notebook.

## Documentation

The documentation includes instructions for local installation.

[![Link to Documentation](https://img.shields.io/badge/Documentation-v2008-blue)](https://mdpetters.github.io/Atmospheric-Physics-Notebooks/dev/) &mdash; **Detailed documentation of version v2008 in HTML format.**


## Project Status
The Docker image can be run on Linux, maxOS, or Windows. The current version of the project is being developed for Julia `1.4` and above on Linux. It very likely works on native macOS and Windows Julia installs.  The versioning scheme is vYYMM, where YY is the year and MM is the month. Major version updates are expected once per year. 

## Contribute
Contributions including new revisions, correction, or new ideas for notebooks are welcome.
