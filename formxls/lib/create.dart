import 'dart:io';
import 'dart:convert'; // Importante para o JSON
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormXls',
      theme: ThemeData(),
      home: const CreateFormPage(title: 'FormXls'),
    );
  }
}

class CreateFormPage extends StatefulWidget {
  const CreateFormPage({super.key, required this.title});
  final String title;

  @override
  State<CreateFormPage> createState() => _CreateFormPageState();
}

class _CreateFormPageState extends State<CreateFormPage> {
  // Inicialização correta dos estados
  List<List<String>> dataMap = [[], []];
  late FocusNode _foco;
  final TextEditingController colunasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foco = FocusNode();
  }

  @override
  void dispose() {
    _foco.dispose();
    colunasController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    if (colunasController.text.isEmpty) return;

    setState(() {
      if (dataMap[0].isEmpty) {
        colunasController.text.endsWith(".xlsx")
            ? null
            : colunasController.text += ".xlsx";
        dataMap[0].add(colunasController.text);
      } else {
        dataMap[1].add(colunasController.text);
      }
    });

    colunasController.clear();

    // Garante que o foco volte após o frame ser desenhado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _foco.requestFocus();
    });
  }

  Future<void> createXLS() async {
    String columnsString = '';
    String valuesStrings = '';

    for (int i = 0; i <= dataMap[1].length-1; i++) {
    valuesStrings +=  i >= dataMap[1].length-1 ? "" :  ",";
    }

      for (int i = 0; i <= dataMap[1].length-1; i++) {
    columnsString +=  i >= dataMap[1].length-1 ? dataMap[1][i] :  "${dataMap[1][i]},";
    }

    try {
      print(columnsString);
      print(valuesStrings);
      final resultado = await Process.run('./.venv/bin/python3', [
        './src/main/python/main.py',
        'POST/forms',
        dataMap[0][0].startsWith('/')
            ? "${widget.title}\\${dataMap[0][0]}"
            : "${widget.title}/${dataMap[0][0]}",
        columnsString,
        valuesStrings,
      ]);

      if (resultado.exitCode == 0) {
        print("Sucesso Python: ${resultado.stdout}");
      } else {
        print("Erro no Script Python: ${resultado.stderr}");
      }
    } catch (e) {
      print("Erro ao tentar executar o processo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dataMap[0].isEmpty
              ? widget.title
              : (dataMap[0][0].startsWith('/')
                    ? "${widget.title}\\${dataMap[0][0]}"
                    : "${widget.title}/${dataMap[0][0]}"),
        ),
        centerTitle: true,
      ),
      body: Center(
      child: 
      Column(
        children: [
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            focusNode: _foco,
            textAlign: TextAlign.center,
            controller: colunasController,
            onSubmitted: (_) => _incrementCounter(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: dataMap[0].isEmpty
                  ? "Nome do arquivo (.xlsx)"
                  : "Nome da Coluna ${dataMap[1].length + 1}",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.blueGrey),
                onPressed: _incrementCounter,
              ),
            ),
          ),
        ),
        Text(dataMap[0].isNotEmpty ? dataMap[0][0] : ''),
        if(dataMap[1].isNotEmpty)...[
          for(var columns in dataMap[1])...[
            Text(columns)
          ]
        ]
        ],
      ),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: dataMap[1].isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: createXLS,
              label: const Text("Criar Planilha"),
              icon: const Icon(Icons.table_chart),
            )
          : null,
    );
  }
}
