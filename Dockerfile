# Dockerfile for building Atmospheric-Physics-Notebook container

FROM jupyter/minimal-notebook

LABEL maintainer="Markus Petters <mdpetter@ncsu.edu>"

USER root

# Install system packages dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libfftw3-dev \
    vim \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Environment Variables
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.4.0
ENV JULIA_SHA256=30d126dc3598f3cd0942de21cc38493658037ccc40eb0882b3b4c418770ca751
ENV JULIA_PROJECT=$HOME

# Download and install julia version
RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "${JULIA_SHA256} *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

USER $NB_UID

# Python dependencies for pyrcel model
RUN conda config --add channels conda-forge

RUN conda install --yes \
    pip \
    numpy \
    cython \
    numba \
    future \
    pandas \
    assimulo && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install pyrcel

# Download notebooks
RUN git clone https://github.com/mdpetters/Atmospheric-Physics-Notebooks.git && \
    cp -r $HOME/Atmospheric-Physics-Notebooks/*.* . && \
    cp -r $HOME/Atmospheric-Physics-Notebooks/* . && \
    rm -rf $HOME/work && \
    rm -rf $HOME/Atmospheric-Physics-Notebooks

# Activate julia environment and precompile
RUN julia -e 'using Pkg; Pkg.instantiate()' && \
    julia -e 'using Pkg; Pkg.status()' && \
    julia -e 'println(Base.active_project())' 

RUN mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

#USER root

# Install WebIO jupyter extension
RUN julia -e 'using WebIO; WebIO.install_jupyter_nbextension();' 

# Copy libraries for Fezzik precompile to succeed
USER root

RUN ls
RUN pwd
RUN cp $JULIA_PKGDIR/packages/GR/yMV3y/deps/gr/lib/*.so ${JULIA_DEPOT_PATH}-${JULIA_VERSION}/lib/julia/ && \
    cp $HOME/bootstrap.jl $JULIA_PKGDIR/packages/Fezzik/SfTjP/src/ && \
    chmod a+w ${JULIA_DEPOT_PATH}-${JULIA_VERSION}/lib/julia/ && \
    chmod a+w ${JULIA_DEPOT_PATH}-${JULIA_VERSION}/etc/julia/startup.jl 

USER $NB_UID


RUN echo 'using Fezzik; Fezzik.trace();' >> ${JULIA_DEPOT_PATH}-${JULIA_VERSION}/etc/julia/startup.jl && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 01 - Aerosol Dynamics/Module 1 - Aerosol Dynamics.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 02 - Cloud Condensation Nuclei/Module 2 - Cloud Condensation Nuclei.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 03 - Early Stages of Cloud Formation/Module 3 - Early Stages of Cloud Formation.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 04 - Cloud Droplet Size Distributions/Module 4 - Cloud Droplet Size Distributions.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 05 - Droplet Growth by Condensation/Module 5 - Droplet Growth by Condensation.ipynb" --stdout >/dev/null  && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 06 - Droplet Growth by Collision and Coalescence/Module 6 - Droplet Growth by Collision and Coalescence.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 07 - Influence of Aerosol on Precipitation/Module 7 - Influence of Aerosol on Precipitation.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 08 - Raindrop Size Distributions/Module 8 - Raindrop Size Distributions.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 09 - Interactions of Radiation with Bulk Matter/Module 9 - Interactions of Radiation with Bulk Matter.ipynb" --stdout >/dev/null && \
    jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 "notebooks/Module 10 - Interactions of Radiation with Droplets/Module 10 - Interactions of Radiation with Droplets.ipynb" --stdout >/dev/null

RUN julia -e 'using Fezzik; Fezzik.brute_build_julia(;clear_traces = true);'
