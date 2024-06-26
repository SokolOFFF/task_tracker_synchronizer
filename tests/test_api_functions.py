
from unittest.mock import patch, mock_open
import json
import sys  # noqa: E402
sys.path.insert(0, './src/')
import api_functions  # noqa: E402


@patch('api_functions.__get_jira_issue_data')
def test_get_jira_issue_json(mock_get_jira_data):
    mock_jira_issue_data = {
        "fields": {
            "summary": "Test summary",
            "description": {
                "content": [
                    {"content": [{"text": "Test description"}]}
                ]
            },
            "status": {"name": "Open"},
            "priority": {"name": "High"},
            "customfield_10016": 5,
            "duedate": "2023-05-01"
        }
    }
    mock_get_jira_data.return_value = mock_jira_issue_data
    result = api_functions.get_jira_issue_json('TEST-123')
    expected_result = {
        "Summary": "Test summary",
        "Description": "Test description",
        "Status": "Open",
        "Priority": "High",
        "Estimation": 5,
        "Due date": "2023-05-01"
    }
    assert result == expected_result


@patch('api_functions.__get_youtrack_issue_data')
def test_get_youtrack_issue_json(mock_get_youtrack_data):
    mock_youtrack_issue_data = {
        "summary": "Test summary",
        "description": "Test description",
        "customFields": [
            {"name": "State", "value": {"name": "Open"}},
            {"name": "Priority", "value": {"name": "High"}},
            {"name": "Estimation", "value": 5},
            # Timestamp for 2023-05-01
            {"name": "Due Date", "value": 1682899200000}
        ]
    }
    mock_get_youtrack_data.return_value = mock_youtrack_issue_data
    result = api_functions.get_youtrack_issue_json('TEST-123')
    expected_result = {
        "Summary": "Test summary",
        "Description": "Test description",
        "Status": "Open",
        "Priority": "High",
        "Estimation": 5,
        "Due date": "2023-05-01"
    }
    assert result == expected_result


@patch('requests.request')
def test_edit_jira_issue(mock_request):
    mock_config = {
        'jira_get_issue_api': 'https://example.com/jira/rest/api/2/issue/'
    }
    mock_secrets = {
        'jira_auth_token': 'mock_token',
        'jira_auth_email': 'mock_email'
    }
    mock_open_config = mock_open(read_data=json.dumps(mock_config))
    mock_open_secrets = mock_open(read_data=json.dumps(mock_secrets))
    with patch('builtins.open',
               side_effect=[
                   mock_open_config.return_value,
                   mock_open_secrets.return_value]):
        mock_response = {
            "transitions": [
                {"id": 11, "name": "To Do"},
                {"id": 21, "name": "In Progress"},
                {"id": 31, "name": "Done"}
            ]
        }
        mock_request.return_value.status_code = 200
        mock_request.return_value.text = json.dumps(mock_response)

        new_data = {
            "Summary": "Updated summary",
            "Description": "Updated description",
            "Status": "In Progress",
            "Priority": "Medium",
            "Estimation": 10,
            "Due date": "2023-05-10"
        }
        result = api_functions.edit_jira_issue('TEST-123', new_data)
        assert result == 200
