from fastapi import FastAPI
from threading import Thread
import synchronizer
import json

app = FastAPI()

worker = Thread(target=synchronizer.main)
worker.setDaemon(True)
worker.start()

@app.get("/rules/")
def get_rules():
    return synchronizer.rules

@app.get("/task_fields/")
def get_rules():
    return synchronizer.config['task_fields']

def __add_rule(rule):
    json_rule = json.loads(rule)
    all_rules = synchronizer.rules
    task_1 = json_rule['task_id_1']
    task_2 = json_rule['task_id_2']
    all_rules[f'{task_1}_{task_2}'] = json_rule
    print(all_rules)
    with open('../config/config.json', 'w') as f:
        f.write(all_rules)

@app.post("/rule/")
def add_rule(new_rule):
    try:
        __add_rule(new_rule)
        return {"Success": True}
    except Exception:
        return {"Success": False}
    
