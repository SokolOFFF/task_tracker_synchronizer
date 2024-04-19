from time import sleep
from datetime import datetime, timedelta
from api_functions import get_jira_issue_data, get_youtrack_issue_data
import json

config = None
rules = None


# Updates rules
def update_rules():
    global rules
    rules = json.load(open('config/rules.json', 'r'))


# Checks if task trackers are synchronized
def check_synchronization():
    print('Checking...')
    pass


# Main function
def main():
    global config
    config = json.load(open('config/config.json', 'r'))
    frequency = config['frequency']
    max_difference = timedelta(seconds=int(frequency))

    check_synchronization()
    last_time_update = datetime.now()
    while True:
        if datetime.now() - last_time_update > max_difference:
            update_rules()
            check_synchronization()
            last_time_update = datetime.now()
        sleep(1)


if __name__ == '__main__':
    main()
