# backend.py
from daytona import Daytona
from langchain_daytona import DaytonaSandbox

daytona = Daytona()
boxes = daytona.list().items

if boxes:
    sandbox = boxes[0]
else:
    sandbox = daytona.create()

dt_backend = DaytonaSandbox(sandbox=sandbox)
