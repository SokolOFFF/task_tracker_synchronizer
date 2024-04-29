from unittest.mock import patch
from fastapi.testclient import TestClient
import sys
sys.path.insert(0, './src/')
import main  # noqa: E402


client = TestClient(main.app)
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


@patch('synchronizer.main')
def test_invalid_endpoint(mock_main):
    response = client.get("/invalid/")
    assert response.status_code == 404


@patch('api_functions.get_youtrack_issue_json',
       side_effect=Exception('Test Exception'))
def test_get_youtrack_issue(mock_get_youtrack):
    response = client.get("/check_youtrack_issue/TEST-123/")
    assert response.status_code == 200
    assert not response.json()


@patch('api_functions.get_jira_issue_json',
       side_effect=Exception('Test Exception'))
def test_get_jira_issue(mock_get_jira):
    response = client.get("/check_jira_issue/TEST-123/")
    assert response.status_code == 200
    assert not response.json()


def test_task_fields(monkeypatch):
    mock_config = {
        "frequency": 60,
        "task_fields": ["Summary", "Description",
                        "Status", "Priority", "Estimation", "Due date"]
    }
    monkeypatch.setattr('synchronizer.config', mock_config)
    with TestClient(main.app) as client:
        response = client.get("/task_fields/")
        assert response.status_code == 200
        assert response.json() == mock_config["task_fields"]


def test__add_rules():
    mock_rules = {
        "TASK-1_TASK-2": {
            "task_id_1": "TASK-1",
            "task_id_2": "TASK-2",
            "fields": {
                "Summary": {"rule_type": 1},
                "Description": {"rule_type": 1}
            }
        }
    }
    with patch('synchronizer.rules', mock_rules):
        new_rules = [
            '{"task_id_1": "TASK-3", "task_id_2": "TASK-4", ' +
            '"fields": {"Status": {"rule_type": 1}}}',
            '{"task_id_1": "TASK-5", "task_id_2": "TASK-6",' +
            ' "fields": {"Priority": {"rule_type": 1}}}'
        ]
        expected_result = {
            "TASK-1_TASK-2": {
                "task_id_1": "TASK-1",
                "task_id_2": "TASK-2",
                "fields": {
                    "Summary": {"rule_type": 1},
                    "Description": {"rule_type": 1}
                }
            },
            "TASK-3_TASK-4": {
                "task_id_1": "TASK-3",
                "task_id_2": "TASK-4",
                "fields": {
                    "Status": {"rule_type": 1}
                }
            },
            "TASK-5_TASK-6": {
                "task_id_1": "TASK-5",
                "task_id_2": "TASK-6",
                "fields": {
                    "Priority": {"rule_type": 1}
                }
            }
        }
        with patch('builtins.print') as mock_print:
            main.__add_rules(new_rules)
            mock_print.assert_called_with(expected_result)
