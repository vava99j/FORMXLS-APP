class File:
    def __init__(self, file: list):
        self.file = file
        self.dados = {}
        print(f"Arquivo: {self.file}")

    def get_file(self):
        return self.file

    def vincular_columns(self, file, columns:list):
        self.dados[file] = columns
        print(f"Colunas '{self.dados[file]}' vinculados no arquivo '{file}")

