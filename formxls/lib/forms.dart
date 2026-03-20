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
  int _counter = 0;
  List<List> dataMap = [
    [], //file
    [], //table
  ];
  String exibivel = '';
  List checkList = [];

  List<TextEditingController>? controllers;

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

  void _clearCheck() {
    setState(() {
      checkList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Corrigido o erro de sintaxe aqui
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
                          icon: const Icon(Icons.send, color: Colors.blueGrey),
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
          for (var i = 0; i < widget.columnSheetList.length; i++) {
            print(controllers![i].text.toString());
            
          }
        },
        label: const Text("Finish row"),
        icon: const Icon(Icons.description),
      ),
    );
  }
}
