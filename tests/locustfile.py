from locust import HttpUser, task


class TasktrackersUser(HttpUser):
    @task
    def route_1(self):
        self.client.get("/rules/")

    @task
    def route_2(self):
        self.client.get(f"/check_youtrack_issue/{1}/")

    @task
    def route_3(self):
        self.client.get(f"/check_jira_issue/{1}/")

    @task
    def route_4(self):
        self.client.get("/task_fields/")
