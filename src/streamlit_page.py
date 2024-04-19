from UI.generate_new_rule_screen import GenerateNewRuleScreen
from UI.main_screen import MainScreen
import streamlit as st


generate_new_rule_screen = GenerateNewRuleScreen()
main_screen = MainScreen()

def _initial_settings():
    if "app_screen" not in st.session_state:
        # Set the main screen to open initially
        st.session_state.app_screen = main_screen
    if "routes" not in st.session_state:
        st.session_state.routes = {
            main_screen.page_name(): main_screen,
            generate_new_rule_screen.page_name(): generate_new_rule_screen,
        }

def main():
    _initial_settings()
    st.session_state.app_screen.build()


if __name__ == "__main__":
    main()
