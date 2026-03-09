# prompts.py

GRADE_PROMPT = """You are a grader assessing relevance of a retrieved document to a user question.
Here is the retrieved document: \n\n {docs} \n\n
Here is the user question: {question} \n
If the document contains keyword(s) or semantic meaning related to the user question, grade it as relevant.
Give a binary score 'yes' or 'no' to indicate whether the document is relevant to the question.
"""
# ✅ 영어로 변경 - 한국어 질문 + 영어 문서 간 의미론적 매핑 정확도 향상


REWRITE_QUESTION_PROMPT = """너는 검색 쿼리 최적화 전문가야.
아래 전체 대화 내용을 참고해서, 사용자가 진짜로 원하는 것이 무엇인지 파악하고
벡터 검색에 최적화된 질문으로 재작성해줘.

---
전체 대화 맥락:
{conversation_context}
---
원본 질문: {original_question}
---

개선된 질문만 출력할 것 (설명, 부연 없이)
반드시 영어로 출력할 것 (벡터스토어가 영어 문서로 구성되어 있음)
"""  # ✅ {conversation_context} 플레이스홀더 추가 (nodes.py에서 .format()으로 호출)


GENERATE_ANSWER_PROMPT = """당신은 질문-답변 담당 어시스턴트입니다.
다음 제공된 정보를 활용하여 질문에 답하세요.

답을 모르는 경우 모르겠다 라고만 하세요.

답은 최대 3문장으로 간결하게 작성하세요.
제공된 정보가 영어더라도 반드시 한국어로 답하세요.

---

질문: {question}
제공된 정보 : {docs}
"""
# ✅ 영어 문서 → 한국어 답변 지시 추가


FALLBACK_ANSWER_PROMPT = """당신은 AI, LLM 분야 전문 어시스턴트입니다.
관련 문서 검색을 시도했지만 적절한 문서를 찾지 못했습니다.
당신이 알고 있는 지식을 바탕으로 아래 질문에 최선을 다해 답변해 주세요.

검색된 자료가 없기 때문에, 답변이 불확실하거나 최신 정보가 아닐 수 있음을 사용자에게 안내하세요.
답은 최대 3문장으로 간결하게 작성하세요.

---
질문: {question}
"""