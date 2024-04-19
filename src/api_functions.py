import requests
from requests.auth import HTTPBasicAuth
import json


# Gets jira issue data
def get_jira_issue_data(issue_key):
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

    return json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": "))


# Gets youtrack data
def get_youtrack_issue_data(issue_key):
    config = json.load(open('config/config.json', 'r'))
    secrets = json.load(open('config/secrets.json', 'r'))

    token = secrets['youtrack_auth_token']

    headers = {
        "Authorization": token,
        "Accept": "application/json",
    }
    url = config['youtrack_get_issue_api'] + str(issue_key)

    response = requests.request(
        "GET",
        url,
        headers=headers
    )

    # print(json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": ")))
    return json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": "))

