import pandas as pd

class Create:
    def __init__(self, nomePath, columns): 
        try:
            self.nome = nomePath
            self.colunas = columns            
            self.df = pd.DataFrame([], columns=self.colunas)
            print(f"Init: Pronto para salvar em {self.nome}")
        except Exception as e:
            print(f"Erro no Init: {e}")
         
    def create(self):
        try:
            self.df.to_excel(self.nome, engine='openpyxl', index=False) 
            print(f"Sucesso! Arquivo criado em: {self.nome}")
        except Exception as e:
            print(f"Erro ao salvar: {e}")