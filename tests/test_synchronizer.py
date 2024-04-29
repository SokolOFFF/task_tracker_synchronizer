# import time
# import threading
import json
from unittest.mock import mock_open, patch
# from src import src.synchronizer
import src.synchronizer
# from src.synchronizer import update_rules, apply_rule, \
#     check_two_tasks_synchronization, check_synchronizations
# from src.synchronizer import update_rules, apply_rule, \
#     check_two_tasks_synchronization, check_synchronizations


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
    assert src.synchronizer.apply_rule(
        task_1_current_data, task_2_current_data,
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
    with patch("src.synchronizer.get_jira_issue_json") \
            as mock_get_jira_issue_json:
        mock_get_jira_issue_json.return_value = {
            "Summary": "Summary1",
            "Status": "Status1"
        }
        with patch("src.synchronizer.get_youtrack_issue_json")\
                as mock_get_youtrack_issue_json:
            mock_get_youtrack_issue_json.return_value = {
                "Summary": "Summary2",
                "Status": "Status2"
            }
            with patch("src.synchronizer.edit_jira_issue") \
                    as mock_edit_jira_issue:
                src.synchronizer.check_two_tasks_synchronization(rule)
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
        src.synchronizer.check_synchronizations()
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
        src.synchronizer.update_rules()
        # from src.synchronizer import rules
        assert src.synchronizer.rules == mock_rules


def test_update_rules_file_not_found(capsys):
    with patch('builtins.open', side_effect=FileNotFoundError):
        src.synchronizer.update_rules()
        assert "Error: Rules file not found" in capsys.readouterr().out


# def test_main(monkeypatch):
#     mock_config = {
#         "frequency": 60,
#         "task_fields":
#         ["Summary", "Description",
#          "Status", "Priority", "Estimation", "Due date"]
#     }
#     mock_rules = {
#         "TASK-1_TASK-2": {
#             "task_id_1": "TASK-1",
#             "task_id_2": "TASK-2",
#             "fields": {
#                 "Summary": {"rule_type": 1},
#                 "Description": {"rule_type": 1},
#                 "Status": {
#                     "rule_type": 2,
#                     "relations": {
#                         "Open": "To Do",
#                         "In Progress": "In Progress",
#                         "Done": "Done"
#                     }
#                 },
#                 "Priority": {"rule_type": 1},
#                 "Estimation": {"rule_type": 1},
#                 "Due date": {"rule_type": 1}
#             }
#         }
#     }
#     monkeypatch.setattr(src.synchronizer, "config", mock_config)
#     monkeypatch.setattr(src.synchronizer, "rules", mock_rules)
#     monkeypatch.setattr(src.synchronizer, "update_rules", lambda: None)
#     monkeypatch.setattr(
#         src.synchronizer, "check_synchronizations", lambda: None)
#     main_thread = threading.Thread(target=src.synchronizer.main)
#     main_thread.start()
#     time.sleep(1)
#     src.synchronizer.stop_event.set()
#     main_thread.join()
#     assert not main_thread.is_alive()
