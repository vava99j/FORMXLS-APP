class style_columnDTO:
    def __init__(self,file, column, back_color, font_color):
        if file and column and back_color and font_color:
            self.file = file
            self.column = column
            self.back_color = back_color
            self.font_color = font_color
            