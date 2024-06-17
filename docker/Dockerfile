FROM condaforge/mambaforge
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    bzip2 \
    cpio \ 
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    libfontconfig1-dev \
    r-base \
    tzdata \
    zip && \
    apt-get clean

WORKDIR /code

# Install CellXGene VIP and R requirements
RUN git clone https://github.com/interactivereport/cellxgene_VIP.git
WORKDIR /code/cellxgene_VIP
RUN conda config --set channel_priority flexible && conda env create -n cellxgene_VIP -f VIP.yml 
RUN conda run -n cellxgene_VIP --live-stream bash ./config.sh
COPY install_r_requirements.sh .
RUN conda run -n cellxgene_VIP --live-stream bash install_r_requirements.sh

# Install CellXGene Gateway
RUN mkdir /code/cellxgene_gateway
WORKDIR /code/cellxgene_gateway
COPY cellxgene_gateway.yml .
RUN conda env create -n cellxgene_gateway -f cellxgene_gateway.yml
# Pulling current git repo - might need to rework this
# The ADD command allows us to invalidate the Docker cache when the repo is updated
ADD https://api.github.com/repos/modulobio/cellxgene-gateway/git/refs/heads/master version.json
RUN conda run -n cellxgene_gateway --live-stream pip install git+https://github.com/modulobio/cellxgene-gateway

ENV RETICULATE_PYTHON=/opt/conda/envs/cellxgene_gateway/bin/python
ENV CELLXGENE_LOCATION=/opt/conda/envs/cellxgene_VIP/bin/cellxgene
ENV EXTERNAL_PROTOCOL=https

CMD [ "conda", "run", "--no-capture-output", "-n", "cellxgene_gateway", "cellxgene-gateway" ]