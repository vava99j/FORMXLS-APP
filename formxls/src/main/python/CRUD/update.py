import os

import pandas as pd

class Update:
    def __init__(self, caminho, file):
     try:
        self.caminho = caminho
        self.file = file[self.caminho]
        print("ca"+ self.caminho+'\n')
        print(self.file)

     except Exception as e:
        print(e)
         
    def update(self):
     try:
        # Converte valores escalares em listas para o DataFrame aceitar
        dados = {k: [v] if not isinstance(v, list) else v for k, v in self.file.items()}
        df_novo = pd.DataFrame(dados)

        with pd.ExcelWriter(self.caminho, engine='openpyxl', mode='a', if_sheet_exists='overlay') as writer:
            # Descobre o nome da primeira aba dinamicamente
            nome_aba = list(writer.sheets.keys())[0] if writer.sheets else 'Sheet1'

            # Descobre a última linha preenchida
            start_row = writer.sheets[nome_aba].max_row

            # Escreve a partir da próxima linha, sem cabeçalho
            df_novo.to_excel(writer, index=False, header=False, startrow=start_row, sheet_name=nome_aba)

        print(f"Dados adicionados com sucesso na aba '{nome_aba}'!")

     except FileNotFoundError:
        # Arquivo não existe: cria do zero com cabeçalho
        dados = {k: [v] if not isinstance(v, list) else v for k, v in self.file.items()}
        df_novo = pd.DataFrame(dados)
        df_novo.to_excel(self.caminho, index=False, sheet_name='Sheet1')
        print("Arquivo não existia, novo arquivo criado.")