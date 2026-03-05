from dotenv import load_dotenv
from langchain.chat_models import init_chat_model
from typing import TypedDict, Literal
from langgraph import graph
from pydantic import BaseModel, Field
from langgraph.graph import StateGraph, START, END
from langgraph.types import interrupt, Command, RetryPolicy
from langchain.messages import HumanMessage

load_dotenv()
llm = init_chat_model('gpt-4.1-mini')


# State 정의
class EmailClassification(TypedDict):
    intent: Literal['question','bug', 'billing', 'feature', 'complex']
    urgency:Literal['low', 'medium', 'high', 'critical']
    topic: str
    summary:str



class EmailAgentState(TypedDict):
    sender_email : str
    email_content : str

    classification : EmailClassification 
    
    search_results : list[str] | None # str 으로 이루어진 list 거나 None 이거나  {a : ['a','b]  {a: None}}
    customer_history: dict | None
    draft_response : str | None
    messages : list[str] | None
    
structured_llm = llm.with_structured_output(EmailClassification)

# ========================================
# 방식 1: Command 병렬
# ========================================

def classify_intent(state: EmailAgentState) -> Command:
    return Command(
        update={"classification": classification},
        goto=["search_documentation", "bug_tracking"]  # 병렬!
    )

# ========================================
# 방식 2: add_conditional_edges 병렬
# ========================================

graph.add_edge("classify_intent", "search_documentation")
graph.add_edge("classify_intent", "bug_tracking")
# 그래프 정의할 때 아예 고정으로 병렬 지정!

# ========================================
# 방법 3: 라우터 함수에서 노드를 리스트로 줘서 병렬
# ========================================

from langgraph.constants import Send

def route_by_intent(state: EmailAgentState):
    return ["search_documentation","bug_tracking"]

graph.add_conditional_edges(
    "classify_intent",
    route_by_intent  # 리스트 반환하면 병렬 실행!
)

# ========================================
# 방법 3: Send (각 노드에 다른 데이터 줄 때)
# ========================================
def route_by_intent(state: EmailAgentState):
    return [                          # query라는 키가 있을때,,!
        Send("search_documentation", {"query": state["classification"]["topic"]}),  # 다른 데이터!
        Send("bug_tracking", {"bug_id": state["classification"]["summary"]})        # 다른 데이터!
    ]

graph.add_conditional_edges(
    "classify_intent",
    route_by_intent  # 리스트 반환하면 병렬 실행!
)


'''
동작 구조 -> 둘 다 동일하게 동작

classify_intent
       │
       ├──────────────────┐
       ▼                  ▼
search_documentation   bug_tracking
       │                  │
       └────────┬─────────┘
                ▼
          다음 노드 (둘 다 끝나면)
'''




# ===========================================
# Command의 goto와 Send는 비슷하지만 차이가 있음!

# Command goto - 현재 state 그대로 전달
Command(goto=["search_documentation", "bug_tracking"])

# Send - 각 노드에 다른 state를 커스텀해서 전달 가능!
'''
Send는 그냥 노드 실행 시 입력값을 넣어주는 것뿐! 공유 State 업데이트 ❌ -> 입력값으로 받고 state update 할거면 노드 안에서 해야함 
'''
Send("search_documentation", {"query": "버그 검색"})
Send("bug_tracking", {"query": "버그 추적"})