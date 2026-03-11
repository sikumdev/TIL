# webapp.py
# slack -> 메시지 들어온 알람 -> webapp.py에서 받고 (FastAPI) -> Agent 실행
# uv pip install fastapi

from fastapi import FastAPI, Request
from app import graph
import uuid
from langgraph_sdk import get_client



app = FastAPI() # 이 순간부터 app이 인터넷에서 오는 요청을 받을 준비가 된거임

client = get_client(url="http://localhost:2024") 



# localhost:2024/slack/webhook
@app.post('/slack/webhook')

async def slack_webhook(req: Request): # Request는 웹훅에서 들어오는 데이터 전체!

    
    '''
    Slack 재시도 요청 무시 -> slack은 3초 이내에 응답 없으면 재시도 요청을 함 (따라서 네트워크 느려지면 답변이 2번 오는 경우가 정말 간혹 있음)

    Slack이 재시도할 때 `X-Slack-Retry-Num` 헤더를 붙여서 보냄

    첫 번째 요청  → X-Slack-Retry-Num 없음
    두 번째 요청  → X-Slack-Retry-Num: 1
    세 번째 요청  → X-Slack-Retry-Num: 2
    '''
    # Slack 재시도 요청이 있다 == X-Slack-Retry-Num이 있다 -> 그래서 있으면 바로 return 해버려서 요청 무시하기
    if req.headers.get('X-Slack-Retry-Num'):
        return {'ok': True}
    
    # 웹훅 데이터 json형태로 가져오기  -> 가져온 후 데이터 형식 확인하기 pprint(payload)
    payload = await req.json()

    event = payload.get('event', {})
  
    text = payload['event'].get('text','')
    files_info = payload['event'].get('files',[])

    # Slack user_id를 thread_id로 사용 (같은 사람은 같은 thread)
    user_id = payload['event'].get('user', str(uuid.uuid4()))
    thread_id = str(uuid.uuid5(uuid.NAMESPACE_DNS, user_id))


    files =[]
    for file in files_info:
        files.append(
        {
            'name': file['name'],
            'link': file['url_private_download']
        }
        )

    # thread 생성
    thread = await client.threads.create() 

    # langgraph dev 서버를 통해 실행함 -> 서버에 실행 요청하고 바로 return {'ok': True}
    await client.runs.create(
        thread_id=thread['thread_id'],
        assistant_id="main_agent",  # langgraph.json 파일에 main_agent로 적어둠
        input={
            'messages': [{'role': 'user', 'content': text}],
            'input_files': files
        }
    )

    return {'ok': True}

    # slack webhook 최초 등록 때만 쓰는 코드
    # return {'challenge': payload['challenge']}


'''
[
{
    'name' : 'sales.csv',
    'link' : '파일 다운받을 수 있는 링크'
}
]
'''



'''
전체 흐름 정리

Slack (웹훅 url 등록)
  ↓ (메시지 발생)
ngrok (터널링)
  ↓
localhost:2024/slack/webhook (웹훅 url -> 즉, 데이터를 받을 곳!)
  ↓
langgraph dev 서버가 수신
  ↓
webapp.py의 @app.post('/slack/webhook') 가 처리
  ↓
client.runs.create() → LangGraph API에 실행 요청
  ↓
graph 실행 + thread 추적 + GUI에 뜸

http.app에 등록한 덕분에 webapp.py가 langgraph dev 서버 안에서 동작하고, SDK로 호출하면 같은 서버 안에서 API를 통해 추적

(참고) LangGraph SDK는 LangGraph API(LangGraph dev) 서버와 통신하는 클라이언트 라이브러리

'''


'''
그래프 흐름 정리:
```
Slack 메시지
    ↓
webapp.py (webhook 수신 및 graph 실행)
    ↓
check_files (라우터 -> 파일 있어?)
    ↓              ↓
 upload        deep_agent
    ↓
inject_paths (파일 경로 프롬프트 주입)
    ↓
deep_agent
'''