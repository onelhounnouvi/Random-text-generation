import os, subprocess, streamlit as st

st.title("Générateur nonsense en OCaml")

APP = "./app"

def check_and_run():
    if not os.path.exists(APP):
        return False, f"NOT FOUND: '{APP}' not in repo deployed to Streamlit Cloud."
    if not os.access(APP, os.X_OK):
        return False, f"NOT EXECUTABLE: '{APP}' exists but is not executable. Try `git update-index --chmod=+x app` locally and push."
    try:
        p = subprocess.run([APP], capture_output=True, text=True, timeout=30)
        return (p.returncode == 0), (p.stdout if p.returncode==0 else f"Exit {p.returncode}\nSTDERR:\n{p.stderr}")
    except PermissionError as e:
        return False, f"PermissionError: {e} (likely platform policy forbids executing binaries)."
    except Exception as e:
        return False, f"Other exception: {e}"

if st.button("Générer"):
    ok, msg = check_and_run()
    if ok:
        st.text(msg)
    else:
        st.error(msg)
