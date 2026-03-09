# vectorstore.py
from bs4.filter import SoupStrainer  # uv pip install beautifulsoup4
from langchain_community.document_loaders import WebBaseLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_core.vectorstores import InMemoryVectorStore



# 해당 블로그에서 우리가 원하는 부분만 골라내기
bs4_strainer = SoupStrainer(class_=('post-title', 'post-header', 'post-content'))

# 인터넷 웹 페이지 여러개를 저장
urls = [
    "https://lilianweng.github.io/posts/2024-11-28-reward-hacking/",
    "https://lilianweng.github.io/posts/2024-07-07-hallucination/",
    "https://lilianweng.github.io/posts/2025-05-01-thinking/",
]

docs = [WebBaseLoader(web_path=url, bs_kwargs={'parse_only': bs4_strainer}).load() for url in urls]

# [ [ Document(metatdata={},  page_content = " ")]  , []   , []  ]
# print(docs)

docs_list = [item for sublist in docs for item in sublist]

# [  Document(metatdata={},  page_content = " ")  ,    ,   ]
docs_list


text_splitter = RecursiveCharacterTextSplitter(
    chunk_size = 1000, chunk_overlap =200, add_start_index=True
)

# [ 문서1, 문서2, 문서3 ] -> chunk 사이즈로 split
chunks = text_splitter.split_documents(docs_list)


embeddings = OpenAIEmbeddings(model='text-embedding-3-small')

vectorstore = InMemoryVectorStore(embedding=embeddings)

ids = vectorstore.add_documents(chunks) # 메서드 실행 시 220개 문서 쪼가리의 id가 출력됨 -> 출력되는거 보고 싶지 않으니 ids 변수애 넣기

retriever = vectorstore.as_retriever(search_kwargs={'k': 4})