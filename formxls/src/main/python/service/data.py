from entity.file import File
from entity.columns import Columns
from entity.values import Values


class Data:
    def __init__(self):
        self.file = None
        self.columns = None
        self.values = None

    def to_handle_file(self, file: list):
        self.file = File(file) 

    def to_handle_column(self, columns: list):
        self.columns = Columns(columns)
    
    def to_handle_values(self , values: list):
        self.values = Values(values) 
        



    def synchronize_create_archive(self):
      for i in range(len(self.columns.column)):
         self.columns.vincular_valores(self.columns.column[i], self.values.values[i])

      for i in range(len(self.file.file)):
         if(self.values.values[0] != ''):
          self.file.vincular_columns(self.file.file[i] , self.columns.dados)
         else:
          self.file.vincular_columns(self.file.file[i] , self.columns.column)

      print(self.file.dados)
      return self.file.dados
    