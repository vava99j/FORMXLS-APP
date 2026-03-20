import pandas as pd

class Create:
    def __init__(self, nome, file):
     try:
        self.nome = nome
        self.file = file
        self.df = pd.DataFrame(self.file[self.nome])
        print("init")
     except Exception as e:
        print(e)
         
    
    def create(self):
          self.df.to_excel(f'{self.nome}.xlsx', engine='openpyxl', index=False)
          print(f"\nSucesso! O arquivo '{self.nome}.xlsx' ESTA NO EXCEL!.")


