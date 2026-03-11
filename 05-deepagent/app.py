# app.py

# entry 파일 -> 최초 실행 파일
from dotenv import load_dotenv
load_dotenv()

from deepagents import create_deep_agent

from tools import send_slack_message, internet_search
from backend import dt_backend
from routers import check_files
from state import State
from langgraph.graph import START, END, StateGraph
from nodes import upload, inject_paths

# 노드로 래핑하는 방법 알아보기
deep_agent = create_deep_agent(
    model = 'openai:gpt-4o-mini',
    tools =[send_slack_message,internet_search],
    backend=dt_backend,
    system_prompt="""
                    You are an AI assistant specialized in data analysis and information retrieval.

                    You must follow these rules:
                    1. Always use the send_slack_message tool to send replies to Slack.
                    2. If a file is provided, analyze the file stored in the sandbox.
                    3. If latest information or web search is needed, use the internet_search tool.
                    4. Never send raw URLs. Always summarize search results in a clear, readable format and send via Slack.
                    5. Always reply in Korean.
                    6. When sending images or files, always use send_slack_message tool with file_path parameter instead of markdown image syntax.
                    """
)

workflow = StateGraph(State)
workflow.add_node('deep_agent',deep_agent) 
workflow.add_node('upload',upload) 
workflow.add_node('inject_paths',inject_paths) 

workflow.add_conditional_edges(
    START,
    check_files,
    {
        'upload': 'upload',
        'deep_agent': 'deep_agent'
    }
)

# workflow.add_edge('upload', 'deep_agent')
workflow.add_edge('upload', 'inject_paths')
workflow.add_edge('inject_paths', 'deep_agent')
workflow.add_edge('deep_agent', END)

graph = workflow.compile()