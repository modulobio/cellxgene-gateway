FROM python:3.11

RUN pip install --upgrade pip
RUN pip install "numpy>1.2,<2.0.0" "pandas<2.0.0" anndata

# Install cellxgene-gateway, custom from source here
COPY . /cellxgene-gateway
RUN pip install /cellxgene-gateway

ENV CELLXGENE_DATA=/cellxgene-data
ENV CELLXGENE_LOCATION=/usr/local/bin/cellxgene

CMD ["cellxgene-gateway"]
