import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FormXls', theme: ThemeData());
  }
}

class FormPage extends StatefulWidget {
  const FormPage({
    super.key,
    required this.title,
    required this.columnSheetList,
  });
  final String title;
  final List columnSheetList;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<TextEditingController>? controllers;
  String row = '';

  @override
  void initState() {
    super.initState();

    handleControllers();
  }

  void handleControllers() {
    controllers = [];
    for (int i = 0; i < widget.columnSheetList.length; i++) {
      controllers!.add(TextEditingController());
    }
  }

  final TextEditingController checkController = TextEditingController();
  Future<void> finishRow() async {
    row = controllers!.map((TextEditingController c) => c.text).join(',');
    final String column = widget.columnSheetList!.join(',');
    print(column);
    try {
      // 2. Limpamos e criamos a String a partir dos controladores
      // Usamos .map para pegar o texto e .join para criar a String separada por vírgulas

      print("Dados formatados para o Python: $row");

      // 3. Chamada ao processo Python
      // Todos os itens dentro da lista [] devem ser Strings
      final resultado = await Process.run('./.venv/bin/python3', [
        './src/main/python/main.py',
        'PATCH/forms',
        widget.title,
        row,
        column,
      ]);

      print("Saída do Python: \n ${resultado.stdout.toString()}");
    } catch (e) {
      print("Erro no Flutter: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var columnSheet
                      in widget.columnSheetList.asMap().entries) ...[
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: controllers?[columnSheet.key],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: columnSheet.value,
                        floatingLabelAlignment: FloatingLabelAlignment.center,

                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          finishRow();
          for (int i = 0; i < widget.columnSheetList.length; i++) {
            controllers?[i].text = '';
          }
        },
        label: const Text("Finish row"),
        icon: const Icon(Icons.description),
      ),
    );
  }
}
