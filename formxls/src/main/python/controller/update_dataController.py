from DTO.dataDTO import dataDTO
from service.update_dataService import Update_dataService

class Update_dataController:
    def __init__(self, arquivo, ):
        self.arquivo = arquivo
    def handle(self):
        try:
            DTO = dataDTO(self.arquivo)
            service = Update_dataService(DTO.file)
            service.update()
        except:
            pass
