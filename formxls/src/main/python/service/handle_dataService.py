from excel.Data import Data
class Handle_dataService:
 def __init__(self, file):
    self.file = file
    self.nome = list(file.keys())[0]
    self.style = []

 def executar(self):
      print("\nDicionário que será enviado ao Pandas:")
      print(self.file)
      repo = Data(self.nome, self.file)
      repo.save()