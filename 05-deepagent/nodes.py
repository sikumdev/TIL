# nodes.py

from langchain_core.messages import HumanMessage, SystemMessage

from state import State
import requests
import os
from backend import dt_backend


'''

{
    'messages': [],
    'files': [  {'name': , 'link':},     ]
    'upload_paths': []


}

'''


#  requests -> HTTP 요청을 보내는 라이브러리 (터미널 curl 과 같은 역할임 )

'''
requests.get(url)      # 데이터 가져오기 (조회)
requests.post(url)     # 데이터 보내기 (생성)
requests.put(url)      # 데이터 수정
requests.delete(url)   # 데이터 삭제

'''

def upload(state: State):
    files = state['input_files']  
    upload_paths = []

    for file in files:
        # 1. Slack에서 파일 다운로드 하기 (인증 헤더 필요)
        #    -> url로 접속해서 파일 다운로드 하기 -> requests.get(url)인데 뒤에 헤더는 인증을 위해 슬랙 봇 토큰으로 신분 증명  (slack파일은 비공개이기 때문)
        response = requests.get(
            file['link'],
            headers={'Authorization': f'Bearer {os.getenv("SLACK_BOT_TOKEN")}'}
        )

        '''
        print(response.status_code)  # 200
        print(response.text)         # 파일 내용 (문자열)
        print(response.content)      # b'\x89PNG\r\n...' (bytes, 바이너리)
        '''

        b_file = response.content

        # 2. sandbox에 업로드 하기
        # 파일 업로드 이후 파일 저장된 위치를 state에 upload_paths에 저장함 
        sandbox_path = f'/home/daytona/data/{file["name"]}'
        dt_backend.upload_files([(sandbox_path, b_file)])
        upload_paths.append(sandbox_path)

    return { 'upload_paths': upload_paths}
    


def inject_paths(state: State):
    upload_paths = state['upload_paths']
    paths_str = '\n'.join(upload_paths)
    
    return {
        'messages': [SystemMessage(content=f"사용자가 업로드한 파일이 sandbox에 저장되었습니다.\n파일 경로:\n{paths_str}\n위 경로를 사용하여 파일을 분석해주세요.")]
    }
