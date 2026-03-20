from CRUD.update import Update
class Update_dataService:
 def __init__(self, file):
    self.file = file
    self.nome = list(file.keys())[0]
    self.style = []

 def update(self):
      print("\nDicionário que será enviado ao Pandas:")
      print(self.file)
      repo = Update(self.nome, self.file)
      repo.update()