#FROM quay.io/jupyter/tensorflow-notebook:cuda-8890fc557a2c
FROM quay.io/jupyter/pytorch-notebook:cuda12-python-3.11.8

USER root
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt update && apt install -y libpq-dev pandoc cuda-toolkit-12-4 && rm -rf /var/lib/apt/lists/*

USER jovyan
COPY action_recognition.py .
COPY YOLOv8-Action-Recognition.ipynb .
COPY requirements.txt .
COPY RAG_Langchain_with_Local_NIM.ipynb .
COPY rag_pgvector_helloworld.ipynb .

RUN python -m pip install -r requirements.txt
COPY TerraformDocsRAGv2.ipynb .
