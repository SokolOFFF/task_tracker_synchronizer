from abc import ABC, abstractmethod
import streamlit as st

class AbstractPage(ABC):
    def open(self):
        st.session_state.app_screen = self

    @abstractmethod
    def build(self):
        pass

    @abstractmethod
    def page_name(self) -> str:
        pass