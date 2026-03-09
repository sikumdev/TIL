# state.py

from typing import Annotated
from langgraph.graph import MessagesState


class GraphState(MessagesState):
    """
    기존 MessagesState를 확장한 커스텀 State.

    MessagesState는 기본적으로 'messages' 필드만 가지고 있음.
    rewrite 횟수를 추적하기 위해 rewrite_count 필드를 추가.

    rewrite_count:
        - 초기값: 0
        - rewrite_question 노드 실행 시마다 +1
        - grade_document 라우터에서 이 값을 보고
          2 이상이면 'generate_fallback_answer'노드로 분기
    """
    rewrite_count: int = 0
