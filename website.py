import subprocess
import streamlit as st

st.set_page_config(page_title="Random text generation", layout="centered")

# Style
st.markdown(
    """
    <style>
    body { background-color: #fbf5ec; }
    .box {
        width: 100%;
        min-height: 200px;
        background: #ffffff;
        border-radius: 18px;
        padding: 16px 20px;
        font-size: 16px;
        line-height: 1.5;
        color: #2b1f1a;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        border: 1px solid #e0e0e0;
        resize: vertical;
        overflow-y: auto;
        white-space: pre-wrap;
        transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }
    .box:hover {
        border-color: #c8c8c8;
        box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    }
    .stButton>button {
        background-color: #f08a3a;
        color: white;
        border-radius: 14px;
        padding: 12px 34px;
        font-weight: 600;
        border: none;
        box-shadow: 0 6px 18px rgba(240,138,58,0.18);
        transition: transform 0.12s ease-in-out, background-color 0.2s;
    }
    .stButton>button:hover {
        transform: scale(1.03);
        background-color: #f59e58;
    }
    .footer {
        text-align: center;
        margin-top: 20px;
        color: #6b6b6b;
        font-size: 13px;
    }
    </style>
    """,
    unsafe_allow_html=True
)

st.markdown("<h1 style='text-align: center;'>Random text generation</h1>", unsafe_allow_html=True)

# Initialisation
if "current_text" not in st.session_state:
    st.session_state.current_text = ""

# Cadran d'affichage
st.markdown(f"<div class='box'>{st.session_state.current_text}</div>", unsafe_allow_html=True)

# Bouton centré
st.markdown("<br>", unsafe_allow_html=True) #espace pour descendre
col1, col2, col3 = st.columns([2, 2, 1])
with col2:
    if st.button("Generate"):
        st.session_state.current_text = ""  # Vider immédiatement le cadran
        try:
            proc = subprocess.run(["./app"], capture_output=True, text=True, timeout=10)
            if proc.returncode == 0:
                st.session_state.current_text = proc.stdout.strip() or "(Le programme a renvoyé une sortie vide.)"
        except FileNotFoundError:
            st.session_state.current_text = "Erreur: './app' introuvable."
        except subprocess.TimeoutExpired:
            st.session_state.current_text = "Erreur: délai dépassé."
        except Exception as e:
            st.session_state.current_text = f"Erreur inattendue: {e}"

# Footer
st.markdown("""
<div class='footer'>
✨ Words born from chaos — enjoy the nonsense ✨<br>
For the first time, double click on the generate button. Sorry for the inconvenience. Working on it
</div>
""", unsafe_allow_html=True)
