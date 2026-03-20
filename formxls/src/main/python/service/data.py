from entity.file import File
from entity.columns import Columns
from entity.values import Values
from entity.style_column import Style_column


class Data:
    def __init__(self):
        self.file = None
        self.columns = None
        self.values = None
        self.style_column = None
        self.style_Row = None

    def to_handle_file(self, file: list):
        self.file = File(file) 

    def to_handle_column(self, columns: list):
        self.columns = Columns(columns)
    
    def to_handle_values(self , values: list):
        self.values = Values(values) 

    def to_create_style_column(self, style_column: list):
        self.style_column = Style_column(style_column)
        return self.style_column

    def synchronize_create_archive(self):
      for i in range(len(self.columns.column)):
         self.columns.vincular_valores(self.columns.column[i], self.values.values[i])
      for i in range(len(self.file.file)):
         self.file.vincular_columns(self.file.file[i] , self.columns.dados)
      print(self.file.dados)
      return self.file.dados
    


class style_columnREs:
    def __init__(self, parameters: list):
        self.back_color = parameters[1]
        self.font_color= parameters[2]
        self.column = parameters[3]

class style_rowRes:
    def __init__(self, parameters: list):
        self.color = parameters[0]
        self.row = parameters[1]
        self.value = parameters[2]
        self.columns = parameters[3]