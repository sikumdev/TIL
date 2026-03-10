# nodes.py

from state import State

from backend import dt_backend

def upload(state: State):
    print('------------------------------------')
    print(state)
    print('------------------------------------')
    # dt_backend.upload_files(
    # [
    #     ('/home/daytona/data/sales_data.csv', csv_bytes)
    # ] 
    # )

    return {'messages': [{'role':'AI', 'content': 'ok'}]}
    



'''

messages : []
files :  [ A파일, B파일 ...]
file_path = '' <- sandbox 파일 경로

'''