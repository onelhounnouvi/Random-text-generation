.PHONY: all build run clean

BIN_DIR=bin
TARGET=$(BIN_DIR)/app
SRC=modules.ml gene_alea.ml main.ml

all: build

# Compilation et lien
$(TARGET): $(SRC)
<TAB>mkdir -p $(BIN_DIR)
<TAB>ocamlc -o $(TARGET) $(SRC)

build: $(TARGET)

run: $(TARGET)
<TAB>./$(TARGET)

clean:
<TAB>rm -f *.cmo *.cmi *.o $(TARGET)