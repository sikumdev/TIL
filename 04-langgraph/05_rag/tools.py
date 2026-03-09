# tools.py
from langchain.tools import tool
from vectorstore import retriever

@tool
def retreive_blog_posts(query: str) -> str:
    """Search and return information from Lilian Weng's blog posts on AI and LLM topics.
    Always use this tool before answering any question about AI, LLMs, reward hacking, hallucination, or related topics."""
    docs = retriever.invoke(query)
    # 전처리 작업 - > docs는 메타데이터를 포함한 리스트 -> LLM은 내용만 들어있는 str이면 충분함. 
    return '\n\n'.join([doc.page_content for doc in docs])