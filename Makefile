.PHONY: all build run clean

BIN_DIR=bin
TARGET=$(BIN_DIR)/app
SRC=modules.ml gene_alea.ml main.ml

all: build

# Compilation et lien
$(TARGET): $(SRC)
  mkdir -p $(BIN_DIR)
  ocamlc -o $(TARGET) $(SRC)

build: $(TARGET)

run: $(TARGET)
  ./$(TARGET)

clean:
  rm -f *.cmo *.cmi *.o $(TARGET)
