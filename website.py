import streamlit as st
import subprocess
import os

st.title("Générateur nonsense OCaml")

# Vérifie si l'exécutable existe
if not os.path.exists("app"):
    st.warning("Compilation en cours…")
    subprocess.run(["make", "build"])

if st.button("Générer"):
    try:
        result = subprocess.run(["./app"], capture_output=True, text=True)
        st.text(result.stdout)
    except FileNotFoundError:
        st.error("L'exécutable OCaml n'a pas été trouvé.")
