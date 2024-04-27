from unittest.mock import patch
import pytest
from unittest.mock import patch, mock_open
import json
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)
mock_rules = {
    "TASK-1_TASK-2": {
        "task_id_1": "TASK-1",
        "task_id_2": "TASK-2",
        "fields": {
            "Summary": {"rule_type": 1},
            "Description": {"rule_type": 1},
            "Status": {
                "rule_type": 2,
                "relations": {
                    "Open": "To Do",
                    "In Progress": "In Progress",
                    "Done": "Done"
                }
            },
            "Priority": {"rule_type": 1},
            "Estimation": {"rule_type": 1},
            "Due date": {"rule_type": 1}
        }
    }
}
mock_task_fields = ["Summary", "Description",
                    "Status", "Priority", "Estimation", "Due date"]


@patch('src.synchronizer.main')
def test_invalid_endpoint(mock_main):
    response = client.get("/invalid/")
    assert response.status_code == 404


@pytest.fixture
def mock_rules():
    return {
        "TASK-1_TASK-2": {
            "task_id_1": "TASK-1",
            "task_id_2": "TASK-2",
            "fields": {
                "Summary": {"rule_type": 1},
                "Description": {"rule_type": 1},
                "Status": {
                    "rule_type": 2,
                    "relations": {
                        "Open": "To Do",
                        "In Progress": "In Progress",
                        "Done": "Done"
                    }
                },
                "Priority": {"rule_type": 1},
                "Estimation": {"rule_type": 1},
                "Due date": {"rule_type": 1}
            }
        }
    }

# TODO
# @patch('src.synchronizer.rules', mock_rules)
# def test_get_rules(mock_rules):
#     response = client.get("/rules/")
#     assert response.status_code == 200
    # assert response.json().get('TASK-1_TASK-2') == mock_rules['TASK-1_TASK-2']


@patch('src.api_functions.get_youtrack_issue_json', side_effect=Exception('Test Exception'))
def test_check_youtrack_issue(mock_get_youtrack):
    response = client.get("/check_youtrack_issue/TEST-123/")
    assert response.status_code == 200
    assert response.json() == False


@patch('src.api_functions.get_jira_issue_json', side_effect=Exception('Test Exception'))
def test_check_jira_issue(mock_get_jira):
    response = client.get("/check_jira_issue/TEST-123/")
    assert response.status_code == 200
    assert response.json() == False
