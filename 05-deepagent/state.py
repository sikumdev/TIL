# state.py

from langgraph.graph import MessagesState

class State(MessagesState):
    # messages
    files: list
    upload_paths: list


'''
{
    'files' : ['/a/b/c.csv', 'x/y/z.py'],
    'upload_paths': ['/home/daytona/data/a.csv', '/home/daytona/data/b.csv', '/home/daytona/data/c.csv']
    'messages':[
        HumanMessage(),
        AiMessage(),
        ToolMessage(),

    ]
}

'''

