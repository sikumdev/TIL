# tools.py

import os
from slack_sdk import WebClient
from langchain.tools import tool

from backend import dt_backend

SLACK_TOKEN = os.getenv('SLACK_BOT_TOKEN')
slack_client = WebClient(token=SLACK_TOKEN)

@tool(parse_docstring=True) # LLM에게 Tool 설명을 docstring 에서 제공 
def send_slack_message(text: str, file_path: str | None = None) -> str:
    """메세지 전송, 경우에 따라 이미지 같은 파일을 첨부함
    
    Args:
        text: (str) 메세지의 내용
        file_path: (str) 파일시스템 상 첨부파일의 경로
    """

    social_channel_id = 'C0A4WTN3V8Q'

    # 첨부 파일 없으면
    if not file_path:
        slack_client.chat_postMessage(channel=social_channel_id, text = text)
    else:
        fp = dt_backend.download_files([file_path])  # sandbox 내에 file_path에서 다운 받음
        slack_client.files_upload_v2( # 슬랙에 파일 업로드
            channel=social_channel_id, # 채널 id
            content=fp[0].content,    # 파일 내용
            initial_comment=text,     # 입력받은 text
        )

    return 'Message sent.'