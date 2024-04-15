import streamlit as st
import json


# TODO: add existing rules display when the page opens
# TODO: fix page refreshing when changing some fields

# Saves rule
def save_rule(first_task_id, second_task_id, rule_type=1, if_field_2_equals='Closed', then_field_1_equals='Ready'):
    # TODO: add task ids checker, if they exist
    # TODO: implement function
    print('Saving rule...')
    st.write("Saved!")


# Generates new rule
def generate_new_rule():
    # TODO: add columns to make it more pretty
    # TODO: add tips

    first_task_id = st.number_input('Insert first task id')
    second_task_id = st.number_input('Insert second task id')
    rule_type = st.radio(
        "Select rule type:",
        ['Type 1', 'Type 2'],
        captions=['Rule field1 = field2', 'Rule eg. if field2 == "Close", then field1 = "Ready for sale"'],

    )
    if rule_type == 'Type 1':
        st.button('Save rule', on_click=save_rule, args=(first_task_id, second_task_id, 1))
    else:
        if_field_2_equals = st.text_input('if field2 equals..')
        then_field_1_equals = st.text_input('then field1 equals..')
        st.button('Save rule', on_click=save_rule, args=(first_task_id, second_task_id, 2, if_field_2_equals, then_field_1_equals))


# Main Function
def main():
    st.title('Task tracker')
    st.button('Add new rule', on_click=generate_new_rule)


if __name__ == "__main__":
    main()
