from freezegun import freeze_time
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


# @patch('src.synchronizer.sleep', return_value=None)
# @patch('builtins.open', new_callable=mock_open, read_data='{"frequency": 10}')
# @freeze_time("2023-04-26 12:00:00")
# def test_main(mock_open, mock_sleep):
#     with patch('src.synchronizer.update_rules') as mock_update_rules:
#         with patch('src.synchronizer.check_synchronizations') as mock_check_synchronizations:
#             main()
#             # Assert that update_rules and check_synchronizations are called once initially
#             mock_update_rules.assert_called_once()
#             mock_check_synchronizations.assert_called_once()
#             # Move time forward by the configured frequency
#             frozen_time = datetime.now() + timedelta(seconds=10)
#             with freeze_time(frozen_time):
#                 main()
#                 # Assert that update_rules and check_synchronizations are called again
#                 assert mock_update_rules.call_count == 2
#                 assert mock_check_synchronizations.call_count == 2
#             # Advance time further and check that the functions are called again
#             frozen_time += timedelta(seconds=10)
#             with freeze_time(frozen_time):
#                 main()
#                 assert mock_update_rules.call_count == 3
#                 assert mock_check_synchronizations.call_count == 3


# @patch('src.synchronizer.sleep', return_value=None)
# @patch('builtins.open', new_callable=mock_open, read_data='{"frequency": 10}')
# @freeze_time("2023-04-26 12:00:00")
# def test_main(mock_open, mock_sleep, time_machine):
#     with patch('src.synchronizer.update_rules') as mock_update_rules:
#         with patch('src.synchronizer.check_synchronizations') as mock_check_synchronizations:
#             main()
#             # Assert that update_rules and check_synchronizations are called once initially
#             mock_update_rules.assert_called_once()
#             mock_check_synchronizations.assert_called_once()
#             # Move time forward by the configured frequency
#             time_machine.tick(delta=timedelta(seconds=10))
#             main()
#             # Assert that update_rules and check_synchronizations are called again
#             assert mock_update_rules.call_count == 2
#             assert mock_check_synchronizations.call_count == 2
#             # Advance time further and check that the functions are called again
#             time_machine.tick(delta=timedelta(seconds=10))
#             main()
#             assert mock_update_rules.call_count == 3
#             assert mock_check_synchronizations.call_count == 3
#             # Stop the infinite loop by advancing time beyond the maximum allowed duration
#             time_machine.move_to(datetime.now() + timedelta(days=1))
