import pandas as pd

class Data:
    def __init__(self, nome, file):
     try:
        self.nome = nome
        self.file = file
        self.df = pd.DataFrame(self.file[self.nome])
        self.styler = self.df
        print("init")
     except Exception as e:
        print(e)

    def style_column(self, back_color, font_color,column_name):
     try:
      self.styler = self.df.style.set_properties(
      **{'background-color': back_color, 'color': font_color}, 
      subset=[column_name]
      )
      print(f"🎨 Coluna '{column_name}' estilizada com sucesso.")
     except Exception as e:
      print(f"red{e}")

    def style_row(self, column ,row, value, color):
            if row[column] == value:
             return [f'background-color: {color}'] * len(row)
         
    
    def save(self):
          self.styler.to_excel(f'{self.nome}.xlsx', engine='openpyxl', index=False)
          print(f"\nSucesso! O arquivo '{self.nome}.xlsx' ESTA NO EXCEL!.")


