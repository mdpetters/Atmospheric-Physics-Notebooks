FROM jupyter/minimal-notebook

LABEL maintainer="Markus Petters <mdpetter@ncsu.edu>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	python3-pip \
    python3-setuptools \
    python3-dev \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/*

ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.3.0

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "9ec9e8076f65bef9ba1fb3c58037743c5abb3b53d845b827e44a37e7bcacffe8 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

USER $NB_UID

RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("WebIO")' && \
    julia -e "using Pkg; pkg\"add IJulia\"; pkg\"precompile\"" && \ 
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

#USER root

#RUN git clone https://github.com/mdpetters/Atmospheric-Physics-Notebooks.git

RUN julia -e 'using WebIO; WebIO.install_jupyter_nbextension();' 

CMD jupyter notebook \
    --ip=* \
    --notebook-dir=$HOME/Atmospheric-Physics-Notebooks/notebooks/


