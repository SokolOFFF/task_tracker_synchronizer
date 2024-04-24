import datetime

import requests
from requests.auth import HTTPBasicAuth
import json


# Gets jira issue data from API
def __get_jira_issue_data(issue_key):
    config = json.load(open('config/config.json', 'r'))
    secrets = json.load(open('config/secrets.json', 'r'))

    url = config['jira_get_issue_api'] + str(issue_key)
    token = secrets['jira_auth_token']
    email = secrets['jira_auth_email']
    auth = HTTPBasicAuth(email, token)

    headers = {
        "Accept": "application/json"
    }

    response = requests.request(
        "GET",
        url,
        headers=headers,
        auth=auth
    )

    return json.loads(response.text)


# Returns json with needed fields from the whole API data
def get_jira_issue_json(issue_key):
    whole_data = __get_jira_issue_data(issue_key)
    fields = whole_data['fields']
    summary = fields['summary']
    description = fields['description']['content'][0]['content'][0]['text']
    status = fields['status']['name']
    priority = fields['priority']['name']
    estimation = fields['customfield_10016']
    due_date = fields['duedate']

    return {"Summary": summary, 'Description': description, "Status": status, "Priority": priority, "Estimation": estimation, "Due date": due_date}


# Gets youtrack data from API
def __get_youtrack_issue_data(issue_key):
    config = json.load(open('config/config.json', 'r'))
    secrets = json.load(open('config/secrets.json', 'r'))

    token = secrets['youtrack_auth_token']

    headers = {
        "Authorization": token,
        "Accept": "application/json",
    }
    url = config['youtrack_get_issue_api'] + str(issue_key) + "?fields=$type,id,summary,description,customFields($type,id,name,value($type,name))"

    response = requests.request(
        "GET",
        url,
        headers=headers
    )

    return json.loads(response.text)


# Returns json with needed fields from the whole API data
def get_youtrack_issue_json(issue_key):
    whole_data = __get_youtrack_issue_data(issue_key)
    summary = whole_data['summary']
    description = whole_data['description']
    status = ''
    priority = ''
    estimation = ''
    due_date = ''

    for field in whole_data['customFields']:
        if field['name'] == 'State':
            status = field['value']['name']

        if field['name'] == 'Priority':
            priority = field['value']['name']

        if field['name'] == 'Estimation':
            estimation = field['value']

        if field['name'] == 'Due Date':
            due_date = datetime.datetime.fromtimestamp(field['value'] / 1000).strftime("%Y-%m-%d")

    return {"Summary": summary, 'Description': description, "Status": status, "Priority": priority, "Estimation": estimation, "Due date": due_date}


# Function which edits jira issue
def edit_jira_issue(issue_key, new_json_data):
    config = json.load(open('config/config.json', 'r'))
    secrets = json.load(open('config/secrets.json', 'r'))

    url = config['jira_get_issue_api'] + str(issue_key)
    token = secrets['jira_auth_token']
    email = secrets['jira_auth_email']
    auth = HTTPBasicAuth(email, token)

    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }

    payload = json.dumps(
    {
        "fields": {
            "summary": new_json_data['Summary'],
            "customfield_10016": new_json_data['Estimation'],
            "duedate": new_json_data['Due date'],
            "priority": {
                "name": new_json_data['Priority']
            },
            "description": {
                            "type": "doc",
                            "version": 1,
                            "content": [
                                {
                                    "type": "paragraph",
                                    "content": [
                                        {
                                            "text": new_json_data['Description'],
                                            "type": "text"
                                        }
                                    ]
                                }
                            ]
                        }
          }
    })

    response = requests.request(
        "PUT",
        url,
        data=payload,
        headers=headers,
        auth=auth
    )

    url = config['jira_get_issue_api'] + str(issue_key) + "/transitions"
    response = requests.request(
        "GET",
        url,
        headers=headers,
        auth=auth
    )
    transitions_info = json.loads(response.text)
    transition_id = 0
    for transition in transitions_info['transitions']:
        if transition['name'] == new_json_data['Status']:
            transition_id = transition['id']

    payload = json.dumps(
    {
        "transition": {"id": transition_id}
    })
    response = requests.request(
        "POST",
        url,
        data=payload,
        headers=headers,
        auth=auth
    )

    return response.status_code