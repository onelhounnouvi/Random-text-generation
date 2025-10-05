.PHONY: all build run clean

# Cible par défaut
all: build

# Compilation des modules communs
modules: modules.ml gene_alea.ml
	ocamlc -c modules.ml gene_alea.ml

# Binaire principal (utilise ptable.bin)
app: modules main.ml
	ocamlc -o app modules.cmo gene_alea.cmo main.ml

# Tout compiler
build: app

# Exécuter le générateur
run: app
	./app

# Nettoyage
clean:
	rm -f *.cmo *.cmi *.o app prepare
