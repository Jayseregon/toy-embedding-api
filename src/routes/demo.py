from fastapi import APIRouter
from pydantic import BaseModel

from ..services.keywordEmbedding import Embeddings, EmbeddingService

router = APIRouter(prefix="/demo", tags=["demo"])


class DemoRequest(BaseModel):
    text: str


@router.post("/process", response_model=Embeddings)
async def process_demo_text(request: DemoRequest):
    """Process a demo text by splitting it into words and creating embeddings."""
    # Simple word splitting (you might want to add more sophisticated tokenization)
    keywords = request.text.split()
    embedding_service = EmbeddingService()
    return embedding_service.process_keywords(keywords)
