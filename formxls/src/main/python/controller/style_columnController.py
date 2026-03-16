from DTO.style_columnDTO import style_columnDTO
from service.style_columnService import style_columnService
class Style_columnController:
    def __init__(self,file ,column, back_color , font_color ):
        self.file = file
        self.column = column
        self.back_color = back_color
        self.font_color = font_color

    def handle(self):
        try:
            DTO = style_columnDTO(self.file, self.column, self.back_color , self.font_color)
            service = style_columnService(DTO.file, DTO.column, DTO.back_color, DTO.font_color)
            service.executar()
        except:
            pass    