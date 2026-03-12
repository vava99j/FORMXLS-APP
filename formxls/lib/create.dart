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
      theme: ThemeData(
      ),
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
  int _counter = 0;
  List<List> dataMap = [
    [], //file
    [], //table
  ];
  String exibivel = '';
  bool _isChecked = false;
  List checkList = [];

  final TextEditingController tabelasController = TextEditingController();
  final TextEditingController checkController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _clearText(TextEditingController fieldText) {
    setState(() {
      fieldText.text = '';
    });
  }

  void _addData(data) {
    setState(() {
      if (data is List) {
        dataMap[_counter].add(List.from(data));
      } else {
        dataMap[_counter].add(data);
      }
    });
  }

  void _addCheck(tableCheck) {
    setState(() {
      checkList.add(tableCheck);
    });
  }

  void _clearCheck() {
    setState(() {
      checkList.clear();
    });
  }

  void _handleSend() {
    if (dataMap[0].isEmpty) {
      if (tabelasController.text.isNotEmpty) {
        if (!tabelasController.text.endsWith('.xlsx')) {
          tabelasController.text += '.xlsx';
        }
        _addData(tabelasController.text);
        _incrementCounter();
        _clearText(tabelasController);
      }
    } else {
      if (checkList.isEmpty) {
        if (tabelasController.text.isNotEmpty) {
          _addCheck(tabelasController.text);
        }
      } else {
        _addData(List.from(checkList));
        _clearCheck();
        _clearText(checkController);
        _clearText(tabelasController);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Corrigido o erro de sintaxe aqui
          children: [
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                controller: tabelasController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: dataMap[0].isEmpty
                      ? "Nome do arquivo (.xlsx)"
                      : "Nome da Tabela ${dataMap[1].length + 1}",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueGrey),
                    onPressed: _handleSend,
                  ),
                ),
              ),
            ),
            if (checkList.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Possui sub-itens (Checks)?"),
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                ],
              ),
            if (_isChecked == true && checkList.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: checkController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Check para: ${checkList[0]}",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blueGrey),
                      onPressed: () {
                        _addCheck(checkController.text);
                        _clearText(checkController);
                      },
                    ),
                  ),
                ),
              ),
              Text(
                "Itens: ${checkList.sublist(1).join(', ')}",
                style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: dataMap[1].isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                _addData(checkList);
                _clearCheck();
                _clearText(checkController);
                _clearText(tabelasController);
              },
              label: const Text("Finalizar Tabela"),
              icon: const Icon(Icons.description),
            )
          : null,
    );
  }
}