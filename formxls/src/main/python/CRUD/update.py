import pandas as pd

class Update:
    def __init__(self, nome, file):
     try:
        self.caminho = nome
        self.file = file[self.caminho]
        print("init")
     except Exception as e:
        print(e)
         
    
    def update(self):
        try:
            # 1. Cria o DataFrame com os novos dados (lembre-se que self.file deve ser o dicionário interno)
            df_novo = pd.DataFrame(self.file)

            # 2. Usa o ExcelWriter no modo 'a' (append)
            with pd.ExcelWriter(self.caminho, engine='openpyxl', mode='a', if_sheet_exists='overlay') as writer:
                
                # O Pandas já carrega o workbook automaticamente nas versões mais recentes.
                # Vamos descobrir o nome da primeira aba dinamicamente para não dar erro:
                nome_aba = list(writer.sheets.keys())[0] if writer.sheets else 'Sheet1'
                
                # 3. Descobre a última linha preenchida na aba correta
                start_row = writer.sheets[nome_aba].max_row
                
                # 4. Escreve os dados novos a partir da próxima linha
                df_novo.to_excel(writer, index=False, header=False, startrow=start_row, sheet_name=nome_aba)
                
            print(f"Dados adicionados com sucesso na aba '{nome_aba}'!")

        except FileNotFoundError:
            # Se o arquivo não existir, criamos um novo do zero
            df_novo = pd.DataFrame(self.file)
            # Ao criar, definimos um nome padrão para a aba
            df_novo.to_excel(self.caminho, index=False, sheet_name='Sheet1')
            print("Arquivo não existia, novo arquivo criado.")

