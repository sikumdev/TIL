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
# 방식 1: add_conditional_edges (라우터)
# ========================================

# 노드: 분류만 함
def classify_intent(state: EmailAgentState) -> dict:
    classification = structured_llm.invoke(...)
    return {"classification": classification}

# 라우터: 분기만 담당 (별도 함수!)
def route_by_intent(state: EmailAgentState) -> str:
    intent = state["classification"]["intent"]
    if intent == "bug":
        return "bug_tracking"
    elif intent == "complex":
        return "human_review"
    else:
        return "draft_response"

# 그래프 연결
graph.add_node("classify_intent", classify_intent)
graph.add_conditional_edges(
    "classify_intent",      # 출발 노드
    route_by_intent,        # 라우터 함수
    {
        "bug_tracking": "bug_tracking",
        "human_review": "human_review",
        "draft_response": "draft_response"
    }
)

# ========================================
# 방식 2: Command
# ========================================

# 노드가 분류 + 분기 동시에 담당!
def classify_intent(state: EmailAgentState) -> Command[Literal["bug_tracking", "human_review", "draft_response"]]:
    classification = structured_llm.invoke(...)
    
    if classification["intent"] == "bug":
        goto = "bug_tracking"
    elif classification["intent"] == "complex":
        goto = "human_review"
    else:
        goto = "draft_response"
    
    # update, goto 는 Command 안에서는 예약어임
    return Command(
        update={"classification": classification},
        goto=goto
    )

# 그래프 연결 - 훨씬 단순!
# add_node()해두면 langgraph가 알아서 이동 명령 내려줌
graph.add_node("classify_intent", classify_intent)
graph.add_node("bug_tracking", bug_tracking)

# add_conditional_edges 필요 없음! ✅

'''
Command는 뭔가?  LangGraph에게 보내는 "업데이트+이동" 명령
goto는 예약어?  Command의 예약어 파라미터 
-> Command 필수?❌ 없어도 동작, 있으면 IDE 지원
'''



'''
========================================
핵심 차이
========================================

add_conditional_edges 방식
┌─────────────────┐     ┌──────────────┐     ┌─────────────┐
│ classify_intent │ --> │ route_by_    │ --> │ bug_tracking │
│  (분류만)        │     │ intent()     │     │ human_review │
│                 │     │ (라우팅만)    │     │ draft_resp.. │
└─────────────────┘     └──────────────┘     └─────────────┘
       노드                  별도 함수              노드들

Command 방식
┌──────────────────────────┐     ┌─────────────┐
│     classify_intent      │ --> │ bug_tracking │
│  (분류 + 라우팅 동시에)    │     │ human_review │
│                          │     │ draft_resp.. │
└──────────────────────────┘     └─────────────┘
       노드 하나로 해결               노드들

'''

'''
# ✅ add_conditional_edges 추천 상황
# 1. 라우팅 로직이 복잡하고 재사용이 필요할 때
# 2. 노드와 분기 로직을 분리해서 관리하고 싶을 때
# 3. 그래프 구조를 시각적으로 명확히 보고 싶을 때

def route_by_intent(state) -> str:
    # 복잡한 라우팅 로직
    # 여러 노드에서 재사용 가능 ✅
    ...

# ✅ Command 추천 상황
# 1. 노드 실행 결과에 따라 동적으로 분기할 때
# 2. 분기 로직이 노드 내부 결과에 강하게 의존할 때
# 3. 코드를 간결하게 유지하고 싶을 때

def classify_intent(state) -> Command:
    result = llm.invoke(...)  # 결과 보고 바로 분기
    goto = result["intent"]   # 노드 내부 결과로 결정 ✅
    return Command(update={...}, goto=goto)

'''
