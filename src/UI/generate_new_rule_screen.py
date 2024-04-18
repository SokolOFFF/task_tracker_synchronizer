import streamlit as st
from UI.abstract_page import AbstractPage


class GenerateNewRuleScreen(AbstractPage):
    def page_name(self):
        return "generate_new_rule"

    def build(self):
        # TODO: add columns to make it more pretty
        # TODO: add tips
        first_task_id = st.number_input("Insert first task id")
        second_task_id = st.number_input("Insert second task id")
        rule_type = st.radio(
            "Select rule type:",
            ["Type 1", "Type 2"],
            captions=[
                "Rule field1 = field2",
                'Rule eg. if field2 == "Close", then field1 = "Ready for sale"',
            ],
        )
        if rule_type == "Type 1":
            st.button(
                "Save rule",
                on_click=lambda: self.save_rule(),
                args=(first_task_id, second_task_id, 1),
            )
        else:
            if_field_2_equals = st.text_input("if field2 equals..")
            then_field_1_equals = st.text_input("then field1 equals..")
            st.button(
                "Save rule",
                on_click=lambda: self.save_rule(),
                args=(
                    first_task_id,
                    second_task_id,
                    2,
                    if_field_2_equals,
                    then_field_1_equals,
                ),
            )

    # Saves rule
    def save_rule(
        self,
        first_task_id,
        second_task_id,
        rule_type=1,
        if_field_2_equals="Closed",
        then_field_1_equals="Ready",
    ):
        # TODO: add task ids checker, if they exist
        # TODO: implement function
        print("Saving rule...")
        st.write("Saved!")
