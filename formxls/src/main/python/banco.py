import sqlite3

class Sql:
    def __init__(self, default_path=""):
        # Conecta ao banco (no Android/Chaquopy, use caminhos absolutos se necessário)
        self.conexao = sqlite3.connect('empresa.db')
        self.cursor = self.conexao.cursor()

        # 1. Criando as tabelas (Adicionei ID na tabela Path para facilitar o UPDATE)
        self.cursor.execute("""
        CREATE TABLE IF NOT EXISTS planilha (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_name TEXT NOT NULL,
            column_name TEXT,
            rules TEXT
        );
        """)
        
        self.cursor.execute("""
        CREATE TABLE IF NOT EXISTS Path (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT
        );
        """)
        self.conexao.commit()

    def post_path(self, default_path):
        self.path = default_path
        self.cursor.execute('SELECT COUNT(*) FROM Path')
        existe_registro = self.cursor.fetchone()[0] > 0

        if not existe_registro:
            self.cursor.execute('INSERT INTO Path (path) VALUES (?)', (self.path,))
            print(self.path)
        else:
            self.cursor.execute('UPDATE Path SET path = ? WHERE id = 1', (self.path,))
            print(self.path)

        self.conexao.commit()

    def get_path(self):
        """Retorna o path salvo para o Flutter usar no início do app"""
        self.cursor.execute('SELECT path FROM Path WHERE id = 1')
        resultado = self.cursor.fetchone()
        print(resultado[0])

    def path_save_sheet(self, file_name, column_file, rules):
        dados = (file_name, column_file, rules)
        self.cursor.execute('''
            INSERT INTO planilha (file_name, column_name, rules) 
            VALUES (?, ?, ?)
        ''', dados)
        self.conexao.commit()
        print("\nPlanilha registrada no banco com sucesso!")

    def fechar_conexao(self):
        self.conexao.close()