import 'dart:convert';
import 'create.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const EscolhaPastaPage());
  }
}

class EscolhaPastaPage extends StatefulWidget {
  const EscolhaPastaPage({super.key});

  @override
  State<EscolhaPastaPage> createState() => _EscolhaPastaPageState();
}

class _EscolhaPastaPageState extends State<EscolhaPastaPage> {
  String? folderString;
  List? sheetList;
  bool fileBool = false;
  bool sheetBool = false;

  @override
  void initState() {
    super.initState();
    _carregarCaminhoSalvo();
  }

  formsNavigation(List columnSheet){
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FormPage(title: 'FormXls', columnSheetList: List<String>.from(columnSheet)),
        ),
      );
    } catch (e) {
      print('erro');
    }
  }

  Future<void> selecionarPasta() async {
    String? local = await FilePicker.platform.getDirectoryPath();

    if (local != null) {
      await _salvarCaminho(local.toString());
      setState(() {
        folderString = local;
      });
      print("Pasta escolhida: $local , $folderString");
    } else {
      print("Nenhuma pasta selecionada.");
    }
  }

  Future<List<File>> listarExecutaveis(String caminho) async {
    final diretorio = Directory(caminho);

    // Lista todos os itens da pasta (arquivos e subpastas)
    List<FileSystemEntity> listaGeral = await diretorio.list().toList();

    // Filtramos apenas os ARQUIVOS que são scripts ou executáveis comuns
    List<File> executaveis = listaGeral.whereType<File>().where((arquivo) {
      String nome = arquivo.path.toLowerCase();

      // Filtro por extensões comuns de "executáveis/scripts"
      return nome.endsWith('.xlsx');
    }).toList();

    return executaveis;
  }

  Future<List<dynamic>> rodarScriptPython(file) async {
    final resultado = await Process.run('./.venv/bin/python3', [
      './src/main/python/main.py',
      'GET',
      file!,
    ]);

    if (resultado.exitCode == 0) {
      print("Colunas: ${jsonDecode(resultado.stdout)[0]}");
      print("Values: ${jsonDecode(resultado.stdout)[1]}");
      print("Tudo: ${jsonDecode(resultado.stdout)}");
      setState(() {
        sheetList = jsonDecode(resultado.stdout);
      });
    } else {
      print("Erro no Python: ${resultado.stderr}");
    }

    return jsonDecode(resultado.stdout)[0];
  }

  Future<void> _carregarCaminhoSalvo() async {
    final resultado = await Process.run('./.venv/bin/python3', [
      './src/main/python/main.py',
      'DATABASE/save_path?',
    ]);

    if (resultado.exitCode == 0) {
      print("Tudo: ${resultado.stdout}");
      setState(() {
        folderString = resultado.stdout.toString().trim();
      });
    } else {
      print("Erro no Python: ${resultado.stderr}");
    }
  }

  Future<void> _salvarCaminho(String path) async {
    final resultado = await Process.run('./.venv/bin/python3', [
      './src/main/python/main.py',
      'DATABASE/save_path!',
      path,
    ]);

    if (resultado.exitCode == 0) {
      print("Tudo sc: ${resultado.stdout}");
    } else {
      print("Erro no Python: ${resultado.stderr}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            setState(() {
              folderString = null;
              sheetList = null;
              fileBool = false;
              sheetBool = false;
            });
          },
          child: Text(
            folderString == null
                ? 'Selecionar Local de Salvamento'
                : 'Spreadsheets',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (folderString == null) ...[
              ElevatedButton.icon(
                onPressed: selecionarPasta,
                icon: const Icon(Icons.folder_open),
                label: const Text("Onde salvar a planilha?"),
              ),
            ] else ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Path:\n$folderString",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (fileBool == true) ...[
                Expanded(
                  child: FutureBuilder<List<File>>(
                    future: listarExecutaveis(folderString!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Text("loading...");
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("None found");
                      }

                      final arquivos = snapshot.data!;

                      return ListView.builder(
                        itemCount: arquivos.length,
                        itemBuilder: (context, index) {
                          String nomeApenas = arquivos[index].path
                              .split('/')
                              .last;
                          return ListTile(
                            leading: const Icon(
                              Icons.terminal,
                              color: Colors.green,
                            ),
                            title: Text(nomeApenas),
                            subtitle: Text(arquivos[index].path),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 20,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    rodarScriptPython(arquivos[index].path);
                                    setState(() {
                                      fileBool = false;
                                      sheetBool = true;
                                      print("object");
                                      print(fileBool);
                                      print(sheetBool);
                                    });
                                  },
                                  icon: const Icon(Icons.apps),
                                  label: const Text("View sheet"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () async {
                                    var columnSheet = await rodarScriptPython(
                                      arquivos[index].path,
                                    );

                                    formsNavigation(
                                      columnSheet,
                                    );
                                  },
                                  icon: const Icon(Icons.article),
                                  label: const Text("Forms"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              print(
                                "Selecionou o script: ${arquivos[index].path}",
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],

              if (fileBool == false && sheetBool == true) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const SizedBox(height: 20), // Espaçamento

                    if (sheetList != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 7,
                        children: [
                          for (
                            int col = 0;
                            col < sheetList![0].length;
                            col++
                          ) ...[
                            Column(
                              spacing: 4,
                              children: [
                                Text(sheetList![0][col].toString()),
                                for (
                                  int val = 0;
                                  val < sheetList![1][col].length;
                                  val++
                                ) ...[Text(sheetList![1][col][val].toString())],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ] else ...[
                      Text("loading..."),
                    ],
                    const SizedBox(height: 20), // Espaçamento
                  ],
                ),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CreateFormPage(title: 'Formxls'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create file"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Espaçamento
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        fileBool = !fileBool;
                        sheetList = null;
                        print(fileBool);
                      });
                    },
                    icon: Icon(
                      fileBool == true ? Icons.folder : Icons.folder_open_sharp,
                    ),
                    label: const Text("View folder"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
