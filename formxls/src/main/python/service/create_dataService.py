from CRUD.create import Create
class Create_dataService:
 def __init__(self, file):
    self.file = file
    self.nome = list(file.keys())[0]
    self.style = []

 def create(self):
      print("\nDicionário que será enviado ao Pandas:")
      print(self.file)
      repo = Create(self.nome, self.file)
      repo.create()