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
# 방식 1: Command goto 리스트 -> 병렬
# ========================================

def classify_intent(state: EmailAgentState) -> Command:
    return Command(
        update={"classification": classification},
        goto=["search_documentation", "bug_tracking"]  # 병렬!
    )

# ========================================
# 방식 2: add_edge 로 여러 노드 연결 (고정 병렬)
# ========================================

graph.add_edge("classify_intent", "search_documentation")
graph.add_edge("classify_intent", "bug_tracking")
# 그래프 정의할 때 아예 고정으로 병렬 지정!

# ========================================
# 방법 3: 라우터 함수에서 노드를 리스트로 줘서 병렬 🎯 -> 실무에서 가장 많이 사용됨
# ========================================

from langgraph.constants import Send

def route_by_intent(state: EmailAgentState):
    return ["search_documentation","bug_tracking"]

graph.add_conditional_edges(
    "classify_intent",
    route_by_intent  # 리스트 반환하면 병렬 실행!
) # 반환값이랑 노드명이 같으면 생략 가능 

# ========================================
# 방법 4: Send (각 노드에 다른 데이터 줄 때)
# ========================================
def route_by_intent(state: EmailAgentState):
    return [                                   # query라는 키가 있을때,,!
        Send("search_documentation", {"query": state["classification"]["topic"]}),  
        Send("bug_tracking", {"bug_id": state["classification"]["summary"]})   
    ]

graph.add_conditional_edges(
    "classify_intent",
    route_by_intent  # 리스트 반환하면 병렬 실행!
)





# ===========================================
# Command의 goto와 Send는 비슷하지만 차이가 있음!

# Command goto - 현재 state 그대로 전달
Command(goto=["search_documentation", "bug_tracking"])

# Send - 각 노드에 다른 state를 커스텀해서 전달 가능!
'''
Send는 그냥 노드 실행 시 입력값을 넣어주는 것뿐! 공유 State 업데이트 ❌ -> 입력값으로 받고 state update 할거면 노드 안에서 해야함 
공유 State 업데이트 조건
        │
        └── "노드"가 return/Command(update={}) 했을 때만!
'''

# ========================================
#  Send 사용 시 state 흐름
# ========================================

# 1. classify_intent 노드 실행 후 공유 State
{
    "sender_email": "user@example.com",
    "email_content": "버그 발생...",
    "classification": {"intent": "bug", "topic": "로그인 오류"},
    "query": None  # ← 여전히 None!
}

# 2. Send로 search_documentation 실행
Send("search_documentation", {"query": "로그인 오류"})
# search_documentation 노드가 {"query": "로그인 오류"} 를 받아서 실행
# 공유 State의 query는 아직 None 그대로!

# 3. 공유 State query가 업데이트 되려면
# search_documentation 노드가 직접 return 해야 함!
def search_documentation(state: EmailAgentState) -> Command:
    query = state["query"]
    return Command(
        update={"query": query},  # ← 이렇게 return 해야 공유 State 업데이트! ✅
        goto="draft_response"
    )


'''
나머지 패턴은 언제?
add_edge 두 번        → 항상 고정 병렬일 때
Command goto 리스트   → 노드 안에서 바로 분기 결정할 때
Send                  → map-reduce 패턴일 때 (동일 노드 N번)

'''