import pandas as pd
from CRUD.update import Update
from service.data import Data
from CRUD.read import Read
from banco import Sql
from controller.create_dataController import Create_dataController
from controller.update_dataController import Update_dataController
import sys
import json



def UPDATE(path , columns, rows):
   try: 
      servico = Data()
      servico.to_handle_file(path)
      servico.to_handle_column(columns)
      servico.to_handle_values(rows)
      dados_finais = servico.synchronize_create_archive()
      print(dados_finais)
     
   except(e):
     print(e)

UPDATE(
 ["/home/jorge/Documentos/planilhas/Tabela_Projetos_Colorida.xlsx"], 
 ['Projeto', 'Status', 'Orcamento'] , 
 ['excel', 'em andamentoo', '0']
 )

