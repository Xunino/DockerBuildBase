FROM nvidia/cuda:11.2.0-devel-ubuntu18.04

# Setup language, ...
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive PATH=/opt/conda/bin:/home/app.local/bin:$PATH LRU_CACHE_CAPACITY=1 CONDA_DIR=/opt/conda

# Copy files
COPY ./face.yml /home
COPY ./base_env.sh /home

WORKDIR /home

# Download git, python, update
RUN apt-get update --fix-missing && apt-get install -yq --no-install-recommends \
	  python3-opencv ca-certificates python3-dev git wget sudo libjemalloc-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get install -y libnccl-dev

# Download miniconda, setup to bashrc
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    $CONDA_DIR/bin/conda install -y python=$PYTHON_VERSION && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN conda init bash
RUN conda env create -f face.yml
RUN echo "conda activate face" >> ~/.bashrc
RUN eval "$(conda shell.bash hook)"

RUN git config --global http.sslverify "false" && bash base_env.sh

# # CMD ["/bin/bash", "/home/app/face_system/app/config/start.sh"]
