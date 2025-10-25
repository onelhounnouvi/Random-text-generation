# Random Text Generation with Markov Chains

## 📖 Description
Ce projet implémente un générateur de texte aléatoire en **OCaml**, avec une interface utilisateur en **Streamlit** 
(que vous trouverez [ici](https://random-text-generation.streamlit.app/))
L’objectif est de produire des phrases pseudo‑naturelles à partir d’un corpus, en utilisant des **chaînes de Markov**.

---

## 🧠 Chaînes de Markov
Une chaîne de Markov est un modèle probabiliste où l’état suivant dépend uniquement de l’état courant.  
Dans ce projet :
- Les **états** sont les mots (ou séquences de mots).
- Les **transitions** sont les probabilités de passer d’un mot à un autre.
- La génération simule un parcours aléatoire de `START` à `STOP`.

---

## ⚙️ Approches implémentées

### 1. Listes de successeurs (Part A)
- On construit une table de successeurs : chaque mot est associé à la liste des mots qui peuvent le suivre.
- La génération choisit aléatoirement un mot suivant dans cette liste.

### 2. Distributions pondérées (Part B)
- On améliore le modèle en construisant une distribution de probabilités des successurs pour chaque mot.
- Les mots fréquents ont plus de chances d’être choisis.

### 3. Préfixes de longueur variable (Part C)
- On généralise avec des préfixes des **n‑grammes** (préfixes de longueur `n`).
- Chaque mot dépend des n mots précédents.
- Plus `n` est grand, plus le texte est cohérent.

---

## 🚀 Utilisation

Cloner le dépôt
```bash
git clone hhttps://github.com/onelhounnouvi/Random-text-generation.git
cd Random-text-generation
```

### Compilation
```bash
make
./bin/app
```

## 📚 Corpus
- Les textes par défaut proviennent de **[Projet Gutenberg](https://www.gutenberg.org/)**, une bibliothèque numérique de livres du domaine public.  
- Si vous souhaitez utiliser **vos propres livres ou corpus**, il faut :
  1. Placer les fichiers textes dans un dossier books.
  2. Modifier le `Makefile` pour compiler également `prepare.ml`
