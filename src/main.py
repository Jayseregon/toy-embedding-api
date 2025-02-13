from fastapi import FastAPI
from pydantic import BaseModel

from .services.keywordEmbedding import Embeddings, EmbeddingService

app = FastAPI()


class Keywords(BaseModel):
    keywords: list[str]


@app.get("/")
async def read_root():
    return {"greatings": "Welcome to the keyword embeddings API!"}


@app.post("/embeddings", response_model=Embeddings)
async def create_embeddings(keywords: Keywords):
    embedding_service = EmbeddingService()
    return embedding_service.process_keywords(keywords.keywords)
