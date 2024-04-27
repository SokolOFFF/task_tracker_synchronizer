from fastapi import FastAPI
from threading import Thread
import synchronizer
import api_functions
import json
from pydantic import BaseModel

class Rules(BaseModel):
    rules: list

app = FastAPI()

worker = Thread(target=synchronizer.main)
worker.setDaemon(True)
worker.start()


@app.get("/rules/")
def get_rules():
    return synchronizer.rules


@app.get("/task_fields/")
def get_rules():
    return synchronizer.config["task_fields"]


@app.get("/check_youtrack_issue/{issue_id}/")
def get_youtrack_issue(issue_id):
    try:
        api_functions.get_youtrack_issue_json(issue_id)
        return True
    except Exception:
        return False


@app.get("/check_jira_issue/{issue_id}/")
def get_jira_issue(issue_id):
    try:
        api_functions.get_jira_issue_json(issue_id)
        return True
    except Exception:
        return False


def __add_rules(rules):
    new_rules = [json.loads(rule) for rule in rules]
    all_rules = synchronizer.rules
    for r in new_rules:
        task_1 = r["task_id_1"]
        task_2 = r["task_id_2"]
        all_rules[f"{task_1}_{task_2}"] = r
    print(all_rules)
    # with open("../config/config.json", "w") as f:
    #     f.write(all_rules)


@app.post("/rules/")
def add_rules(new_rules: Rules):
    try:
        __add_rules(new_rules.rules)
        return {"Success": True}
    except Exception:
        return {"Success": False}
