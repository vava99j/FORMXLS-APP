from DTO.dataDTO import dataDTO
from service.create_dataService import Create_dataService

class Create_dataController:
    def __init__(self, arquivo, ):
        self.arquivo = arquivo
    def handle(self):
        try:
            DTO = dataDTO(self.arquivo)
            service = Create_dataService(DTO.file)
            service.create()
        except:
            pass
