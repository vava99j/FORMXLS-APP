class Columns:
    def __init__(self, columns:list):
        self.column = columns
        self.dados = {}
        print(f"Colunas criadas: {columns}")

    def vincular_valores(self, coluna, values: list):
         if not values or all(not v for v in values):
          print("lista vazia")
          print("list is null")
         else:
          self.dados[coluna] = values
          print(f"Dados '{self.dados[coluna]}' vinculados na coluna '{coluna}'")