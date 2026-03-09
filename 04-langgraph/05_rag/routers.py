# routers.py

from pydantic import BaseModel, Field
from langchain.chat_models import init_chat_model

from prompts import GRADE_PROMPT
from state import GraphState


grader_llm = init_chat_model('gpt-4.1', temperature=0)

MAX_REWRITE_COUNT = 2  # rewrite 최대 허용 횟수


class GradeDocuments(BaseModel):
    '''문서를 yes/no 로 질문과 관련이 있는지 체크 후 다음 노드 결정'''
    binary_score: str = Field(description='연관성 점수: 연관 있으면 "yes", 아니면 "no"')


def grade_document(state: GraphState):
    """
    검색해온 문서가 사용자 질문과 관련이 있는지 체크.

    라우팅 로직:
    1. rewrite_count >= MAX_REWRITE_COUNT(2) 이면
       → 더 이상 rewrite 하지 않고 'generate_fallback_answer'로 분기
    2. 문서 연관성 'yes' → 'generate_answer'
    3. 문서 연관성 'no' + rewrite 여유 있음 → 'rewrite_question'
    """
    question = state['messages'][0].content
    docs = state['messages'][-1].content
    rewrite_count = state.get('rewrite_count', 0)

    # rewrite를 이미 MAX 횟수만큼 했으면 fallback으로 보내기
    if rewrite_count >= MAX_REWRITE_COUNT:
        print(f"[Router] rewrite {rewrite_count}회 초과 → fallback 답변 생성")
        return 'generate_fallback_answer'

    # 문서 관련성 평가
    prompt = GRADE_PROMPT.format(question=question, docs=docs)
    ollm = grader_llm.with_structured_output(GradeDocuments)
    res = ollm.invoke([{'role': 'user', 'content': prompt}])

    score = res.binary_score

    if score == 'yes':
        print(f"[Router] 문서 관련성 확인 → generate_answer")
        return 'generate_answer'
    else:
        print(f"[Router] 문서 관련성 없음 (rewrite {rewrite_count + 1}회차) → rewrite_question")
        return 'rewrite_question'