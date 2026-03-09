# graph.py
from dotenv import load_dotenv
load_dotenv()

from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode, tools_condition

from state import GraphState
from nodes import generate_answer, rewrite_question, generate_query_or_respond, generate_fallback_answer
from routers import grade_document
from tools import retreive_blog_posts


# MessagesState 대신 rewrite_count가 추가된 커스텀 GraphState 사용
workflow = StateGraph(GraphState)

workflow.add_node('generate_query_or_respond', generate_query_or_respond)
workflow.add_node(rewrite_question)
workflow.add_node(generate_answer)
workflow.add_node(generate_fallback_answer)  # 신규: rewrite 초과 시 fallback 답변 노드
workflow.add_node('retrieve', ToolNode([retreive_blog_posts]))

workflow.add_edge(START, 'generate_query_or_respond')

# generate_query_or_respond → tool 호출 여부에 따라 retrieve or END
workflow.add_conditional_edges(
    'generate_query_or_respond',
    tools_condition,
    {
        'tools': 'retrieve',
        '__end__': END,
    }
)

# retrieve → 문서 관련성 및 rewrite 횟수에 따라 3방향 분기
workflow.add_conditional_edges(
    'retrieve',
    grade_document,
    {
        'generate_answer': 'generate_answer',
        'rewrite_question': 'rewrite_question',
        'generate_fallback_answer': 'generate_fallback_answer',  # 신규 경로
    },
)

workflow.add_edge('rewrite_question', 'generate_query_or_respond')
workflow.add_edge('generate_answer', END)
workflow.add_edge('generate_fallback_answer', END)  # fallback도 END로 종료

graph = workflow.compile()