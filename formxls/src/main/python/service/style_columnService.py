from excel.Data import Data
class style_columnService:
 def __init__(self, column, back_color, font_color):
        self.column = column
        self.back_color = back_color
        self.font_color = font_color

 def executar(self):
      repo = Data(self.nome, self.file)
      repo.save()