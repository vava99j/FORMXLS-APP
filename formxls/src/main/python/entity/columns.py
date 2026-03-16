class Columns:
    def __init__(self, columns:list):
        self.column = columns
        self.dados = {}
        print(f"Colunas criadas: {columns}")

    def vincular_valores(self, coluna, values: list):
         self.dados[coluna] = values
         print(f"Dados '{self.dados[coluna]}' vinculados na coluna '{coluna}'")