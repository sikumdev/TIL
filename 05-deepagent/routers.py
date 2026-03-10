# routers.py

from state import State

def check_files(state: State):
    files = state.get('files', [])

    print(files)

    if files:
        return'upload'
    else:
        return 'deep_agent'
