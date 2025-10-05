import streamlit as st
import subprocess

st.title("Générateur nonsense en OCaml")

if st.button("Générer"):
    result = subprocess.run(["./app"], capture_output=True, text=True)
    st.write(result.stdout)
