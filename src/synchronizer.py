from time import sleep
from datetime import datetime, timedelta
from api_functions import get_jira_issue_json, get_youtrack_issue_json, edit_jira_issue
import json

config = None
rules = None


# Updates rules
def update_rules():
    global rules
    rules = json.load(open("../config/rules.json", "r"))


# Applies rule to the data
def apply_rule(task_1_current_data, task_2_current_data, rule):
    task_2_new_data = task_2_current_data.copy()
    for field in rule["fields"]:
        if rule["fields"][field]["rule_type"] == 1:
            task_2_new_data[field] = task_1_current_data[field]
        else:
            relations = rule["fields"][field]["relations"]
            for relation in relations:
                if relation == task_1_current_data[field]:
                    task_2_new_data[field] = relations[relation]
    return task_2_new_data


# Checks if two tasks are synchronized
def check_two_tasks_synchronization(rule):
    print(
        f'Checking synchronization of task {rule["task_id_1"]} and {rule["task_id_2"]}'
    )
    task_2_current_data = get_jira_issue_json(rule["task_id_2"])
    task_1_current_data = get_youtrack_issue_json(rule["task_id_1"])
    new_data = apply_rule(task_1_current_data, task_2_current_data, rule)
    print(f'Updating {rule["task_id_2"]}...')
    edit_jira_issue(rule["task_id_2"], new_data)


# Checks if task trackers are synchronized
def check_synchronizations():
    print("Checking all synchronizations...")
    for rule in rules:
        check_two_tasks_synchronization(rules[rule])


# Main function
def main():
    global config
    config = json.load(open("../config/config.json", "r"))
    frequency = config["frequency"]
    max_difference = timedelta(seconds=int(frequency))

    update_rules()
    check_synchronizations()
    last_time_update = datetime.now()
    while True:
        if datetime.now() - last_time_update > max_difference:
            update_rules()
            check_synchronizations()
            last_time_update = datetime.now()
        sleep(5)


if __name__ == "__main__":
    main()
