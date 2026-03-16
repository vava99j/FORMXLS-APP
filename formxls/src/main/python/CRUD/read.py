import pandas as pd


class Read:
    def __init__(self, file):
        try:
            self.df = pd.read_excel(file)
            self.file = file
        except FileNotFoundError:
            exit()

    def get_quantity(self):
        rows = self.df.shape[0]
        cols = self.df.shape[1]
        return {"linhas": rows, "colunas": cols}

    def get_values(self):
        return [self.df[coluna].tolist() for coluna in self.df.columns]
    
    def get_columns(self):
        """Retorna uma lista com os nomes de todas as colunas da planilha."""
        colunas = self.df.columns.tolist()
        return colunas

    def get_searchInColumn(self, nome_coluna, valor_procurado):
        if nome_coluna in self.df.columns:
            resultado = self.df[self.df[nome_coluna] == valor_procurado]            
            if not resultado.empty:
                print(f"🔍 Achado: '{valor_procurado}' encontrado na coluna '{nome_coluna}'.")
                return resultado 
            else:
                print(f"⚠️ '{valor_procurado}' não encontrado.")
                return None
        else:
            print(f"❌ A coluna '{nome_coluna}' não existe nesta planilha.")
            return None


