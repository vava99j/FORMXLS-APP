import pandas as pd

# 1. CRIAR OS DADOS (A nossa tabela de exemplo)
dados = {
    'Projeto': ['Site', 'App', 'Sistema', 'Redes Sociais'],
    'Status': ['Em Andamento', 'Concluído', 'Atrasado', 'Concluído'],
    'Orcamento': [5000, 12000, 8000, 1500]
}
df = pd.DataFrame(dados)

def pintar_linha_por_status(linha):
    if linha['Status'] == 'Concluído':
        return ['background-color: #d4edda; color: #155724'] * len(linha)
    
    elif linha['Status'] == 'Atrasado':
        return ['background-color: #f8d7da; color: #721c24'] * len(linha)
    else:
        return [''] * len(linha)
tabela_colorida = (
    df.style
    .set_properties(**{'background-color': '#f8f9fa', 'color': '#000080'})
    
    .apply(pintar_linha_por_status, axis=1)
)

# 4. EXPORTAR PARA EXCEL
# Guardamos o resultado final. Lembra-te que precisas da biblioteca 'openpyxl' instalada.
tabela_colorida.to_excel('Tabela_Projetos_Colorida.xlsx', engine='openpyxl', index=False)

print("A tua tabela colorida foi guardada com sucesso no ficheiro Excel!")