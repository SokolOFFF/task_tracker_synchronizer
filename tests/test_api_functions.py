import pytest
from src.synchronizer import update_rules, apply_rule, check_two_tasks_synchronization, check_synchronizations, main
from src.api_functions import get_jira_issue_json, get_youtrack_issue_json, edit_jira_issue
from unittest.mock import patch, mock_open
import io
import itertools
from time import sleep
from datetime import datetime, timedelta
import json


def test_get_jira_issue_data():
    pass


def test_get_jira_issue_json():
    pass


def test_get_youtrack_issue_json():
    pass


def test_edit_jira_issue():
    pass


def test_get_youtrack_issue_data():
    pass
