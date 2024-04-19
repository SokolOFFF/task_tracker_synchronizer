import streamlit as st
from UI.abstract_page import AbstractPage


class MainScreen(AbstractPage):
    def page_name(self):
        return "main_screen"

    def build(self):
        # TODO: add existing rules display when the page opens
        st.title("Task tracker")
        st.button(
            "Add new rule",
            on_click=st.session_state.routes["generate_new_rule"].open,
        )
