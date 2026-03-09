# nodes.py

from langchain_core.messages import HumanMessage, AIMessage, SystemMessage
from langchain.chat_models import init_chat_model
from langgraph.graph import MessagesState

from tools import retreive_blog_posts
from prompts import REWRITE_QUESTION_PROMPT, GENERATE_ANSWER_PROMPT, FALLBACK_ANSWER_PROMPT
from state import GraphState


res_llm = init_chat_model('gpt-4.1', temperature=0)


def generate_query_or_respond(state: GraphState):
    '''LLM이 사용자 대화를 기반으로 바로 답변을 생성하거나 RAG를 위한 query를 결정한다'''
    tllm = res_llm.bind_tools([retreive_blog_posts])
    system = SystemMessage(content="You must always call the retreive_blog_posts tool before responding to ANY user question, no exceptions.")
    res = tllm.invoke([system] + state['messages'])  # 이 줄만 남기기
    return {'messages': [res]}


def rewrite_question(state: GraphState):
    """
    사용자 질문을 전체 대화 맥락을 고려해서 재작성.
    
    변경사항:
    - 기존: messages[0] (원본 질문만) 으로 재작성
    - 변경: 전체 messages 대화 흐름을 프롬프트에 포함시켜 맥락 기반 재작성
    - rewrite_count를 1 증가시켜 state에 반영
    """
    messages = state['messages']

    # 전체 대화 맥락을 문자열로 정리
    # HumanMessage / AIMessage 구분해서 role 표시
    conversation_history = []

    for msg in messages:
        # isinstance() -> 객체가 특정 클래스의 인스턴스인지 확인
        if isinstance(msg, HumanMessage):
            role = "사용자"
        elif isinstance(msg, AIMessage):
            role = "AI"
        else:
            continue  # ToolMessage 등 완전 제외
    
        if msg.content: # Tool 호출 AIMessage는 제외한 HumanMessage와 AIMessage가 history 내역으로 남음
            conversation_history.append(f"[{role}]: {msg.content}")
        '''
        실제 데이터 형태
        conversation_history = [ "[사용자]: 안녕하세요",
                                "[AI]: 안녕하세요 무엇을 도와드릴까요?",
                                "[사용자]: RAG란 무엇인가요?",
                                "[AI]: RAG는 검색 증강 생성입니다.", ]'''

    conversation_context = "\n".join(conversation_history)
    '''[사용자]: 안녕하세요
    [AI]: 안녕하세요 무엇을 도와드릴까요?
    [사용자]: RAG란 무엇인가요?
    [AI]: RAG는 검색 증강 생성입니다. '''
   
    # 원본 질문 (첫 번째 HumanMessage)
    original_question = messages[0].content

    # 전체 맥락 + 원본 질문을 함께 프롬프트에 전달
    prompt = REWRITE_QUESTION_PROMPT.format(
        conversation_context=conversation_context,
        original_question=original_question,
    )

    response = res_llm.invoke([{'role': 'user', 'content': prompt}])

    # rewrite_count 증가
    current_count = state.get('rewrite_count', 0)

    # 재작성된 질문을 HumanMessage로 교체 (그래야 다음 노드에서 사용자 질문으로 인식)
    return {
        'messages': [HumanMessage(content=response.content)],
        'rewrite_count': current_count + 1,
    }


def generate_answer(state: GraphState):
    """RAG 문서를 기반으로 최종 답변 생성"""
    question = state['messages'][0].content  # 원본 질문
    docs = state['messages'][-1].content     # 마지막 RAG 검색 결과

    prompt = GENERATE_ANSWER_PROMPT.format(question=question, docs=docs)
    res = res_llm.invoke([{'role': 'user', 'content': prompt}])
    return {'messages': [res]}


def generate_fallback_answer(state: GraphState):
    """
    rewrite를 2번 시도했지만 관련 문서를 못 찾은 경우,
    RAG 없이 LLM 자체 지식으로만 답변 생성 (fallback).
    
    신규 추가 노드.
    """
    question = state['messages'][0].content  # 원본 질문

    prompt = FALLBACK_ANSWER_PROMPT.format(question=question)
    res = res_llm.invoke([{'role': 'user', 'content': prompt}])
    return {'messages': [res]}
