from service.data import Data
from CRUD.read import Read
from banco import Sql
from controller.create_dataController import Create_dataController
from controller.update_dataController import Update_dataController
import sys
import json


servico = Data()


# Simulando entradas do usuário
servico.to_handle_file(["Relatorio_Vendas"])
servico.to_handle_column(["Nomes", "status", "valor_base", "valor_adicional"])
servico.to_handle_values([
    ["jorge", "davi", "mieri"],
    ["negociando", "fechado", "cancelado"],
    [1000.0, 500.0, 1200.0],
    [250.0, 50.0, 300.0]
    ])
# Sincroniza
dados_finais = servico.synchronize_create_archive()
print(dados_finais)
servico = Update_dataController(dados_finais)
servico.handle()  
'''

def GET(caminho):
   user = Read(caminho)
   valores = user.get_values()
   columns = user.get_columns()
   listGET:list = [columns , valores] 
   print(json.dumps(listGET))

def DATABASE_GET():
   user = Sql()
   user.get_path()

def DATABASE_POST(path):
   user = Sql()
   user.post_path(path)

if __name__ == "__main__":
 method = sys.argv[1]
 if method == 'GET':
  path = sys.argv[2]
  GET(path)
 if method == 'DATABASE/save_path?':
  DATABASE_GET()
 if method == 'DATABASE/save_path!':
  path = sys.argv[2]
  DATABASE_POST(path)
 
  
  
  

 if method == 'POST/forms':
  data = sys.argv[2]
  servico = Create()
  servico.to_handle_file(data[0])
  servico.to_handle_column(data[1])
  servico.to_handle_values(data[2])
  dados_finais = servico.synchronize_create_archive()
  print(dados_finais)
  servico = Hande_dataController(dados_finais)
  servico.handle()

'''
