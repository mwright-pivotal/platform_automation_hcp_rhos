FROM quay.io/jupyter/tensorflow-notebook:cuda-latest

COPY action_recognition.py .
COPY YOLOv8-Action-Recognition.ipynb .
COPY requirements.txt .
COPY RAG_Langchain_with_Local_NIM.ipynb .
COPY rag_pgvector_helloworld.ipynb .

RUN python -m pip install -r requirements.txt

USER root
RUN apt update && apt install -y libpq-dev pandoc && rm -rf /var/lib/apt/lists/*
