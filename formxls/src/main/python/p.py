import pandas as pd

# 1. CARREGAR OS DADOS
# Substitui 'vendas.xlsx' pelo nome do teu ficheiro
# df significa 'DataFrame', que é a "tabela" do Pandas
try:
    df = pd.read_excel('vendas.xlsx')
    print("Ficheiro carregado com sucesso!")
except:
    # Caso não tenhas o ficheiro, criamos um exemplo para testares
    dados = {
        'Data': ['2023-01-01', '2023-01-02', '2023-01-02', '2023-01-03'],
        'Vendedor': ['Ana', 'Bruno', 'Ana', 'Carlos'],
        'Produto': ['Teclado', 'Rato', 'Monitor', 'Teclado'],
        'Quantidade': [10, 5, 2, 8],
        'Preço Unitário': [20, 15, 150, 20]
    }
    df = pd.DataFrame(dados)
    print("Usando dados de exemplo...")

# 2. LIMPEZA DE DADOS (O famoso 'Remover Duplicados')
df = df.drop_duplicates()

# 3. CRIAÇÃO DE COLUNAS (Fórmulas do Excel)
# No Pandas, fazemos a operação na coluna inteira de uma vez
df['Total Venda'] = df['Quantidade'] * df['Preço Unitário']

# 4. FILTRAGEM (O Filtro do cabeçalho)
# Vamos filtrar apenas as vendas da 'Ana'
vendas_ana = df[df['Vendedor'] == 'Ana']

# 5. AGRUPAMENTO (Tabela Dinâmica)
# Somar o Total Venda por Produto
resumo_produtos = df.groupby('Produto')['Total Venda'].sum().reset_index()

# 6. EXPORTAR O RESULTADO
# Criar um novo ficheiro Excel com o resultado final
with pd.ExcelWriter('Relatorio_Final.xlsx') as writer:
    df.to_excel(writer, sheet_name='Dados Completos', index=False)
    resumo_produtos.to_excel(writer, sheet_name='Resumo por Produto', index=False)

print("\nProcessamento concluído! O ficheiro 'Relatorio_Final.xlsx' foi gerado.")