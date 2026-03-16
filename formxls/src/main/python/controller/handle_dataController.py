from DTO.dataDTO import dataDTO
from service.handle_dataService import Handle_dataService

class Hande_dataController:
    def __init__(self, arquivo, ):
        self.arquivo = arquivo
    def handle(self):
        try:
            DTO = dataDTO(self.arquivo)
            service = Handle_dataService(DTO.file)
            service.executar()
        except:
            pass
