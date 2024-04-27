from src.synchronizer import update_rules
from unittest.mock import mock_open, patch
import pytest
from src.synchronizer import update_rules, apply_rule, check_two_tasks_synchronization, check_synchronizations, main
from src.api_functions import get_jira_issue_json, get_youtrack_issue_json, edit_jira_issue
from unittest.mock import patch, mock_open
import io
import itertools
from time import sleep
from datetime import datetime, timedelta
import json


def test_apply_rule():
    task_1_current_data = {
        "Summary": "Summary1",
        "Status": "Status1"
    }
    task_2_current_data = {
        "Summary": "Summary2",
        "Status": "Status2"
    }
    rule = {
        "fields": {
            "Summary": {
                "rule_type": 1
            },
            "Status": {
                "rule_type": 1
            }
        }
    }
    assert apply_rule(task_1_current_data, task_2_current_data,
                      rule) == task_1_current_data


def test_check_two_tasks_synchronization():
    rule = {
        "task_id_1": "task1",
        "task_id_2": "task2",
        "fields": {
            "Summary": {
                "rule_type": 1
            },
            "Status": {
                "rule_type": 1
            }
        }
    }
    with patch("src.synchronizer.get_jira_issue_json") as mock_get_jira_issue_json:
        mock_get_jira_issue_json.return_value = {
            "Summary": "Summary1",
            "Status": "Status1"
        }
        with patch("src.synchronizer.get_youtrack_issue_json") as mock_get_youtrack_issue_json:
            mock_get_youtrack_issue_json.return_value = {
                "Summary": "Summary2",
                "Status": "Status2"
            }
            with patch("src.synchronizer.edit_jira_issue") as mock_edit_jira_issue:
                check_two_tasks_synchronization(rule)
                mock_edit_jira_issue.assert_called_once_with("task2", {
                    "Summary": "Summary2",
                    "Status": "Status2"
                })


@patch('src.synchronizer.check_two_tasks_synchronization')
def test_check_synchronizations(mock_check_two_tasks_synchronization):
    rules = {
        "rule1": {
            "task_id_1": "task1",
            "task_id_2": "task2",
            "fields": {
                "Summary": {
                    "rule_type": 1
                },
                "Status": {
                    "rule_type": 1
                }
            }
        },
        "rule2": {
            "task_id_1": "task3",
            "task_id_2": "task4",
            "fields": {
                "Description": {
                    "rule_type": 1
                }
            }
        }
    }
    with patch('src.synchronizer.rules', rules):
        check_synchronizations()
    assert mock_check_two_tasks_synchronization.call_count == 2
    mock_check_two_tasks_synchronization.assert_any_call(rules["rule1"])
    mock_check_two_tasks_synchronization.assert_any_call(rules["rule2"])


def test_update_rules():
    mock_rules = {
        "rule1": {
            "task_id_1": "task1",
            "task_id_2": "task2",
            "fields": {
                "Summary": {
                    "rule_type": 1
                },
                "Status": {
                    "rule_type": 1
                }
            }
        },
        "rule2": {
            "task_id_1": "task3",
            "task_id_2": "task4",
            "fields": {
                "Description": {
                    "rule_type": 1
                }
            }
        }
    }

    with patch('builtins.open', mock_open(read_data=json.dumps(mock_rules))):
        update_rules()
        from src.synchronizer import rules

        assert rules == mock_rules


def test_update_rules_file_not_found(capsys):
    with patch('builtins.open', side_effect=FileNotFoundError):
        update_rules()
        assert "Error: Rules file not found" in capsys.readouterr().out

# TODO: Add tests for the main function
