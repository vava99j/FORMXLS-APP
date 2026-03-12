import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final String title;
  final String? initialFileName;

  const FormPage({super.key, required this.title, this.initialFileName});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Alterado o nome para ficar mais claro que é um controlador de texto
  late TextEditingController _fileNameController;
  final _tableController = TextEditingController();
  bool _isPredefined = false;

  @override
  void initState() {
    super.initState();
    // CORREÇÃO: Inicializando o controlador corretamente com o valor vindo do widget
    _fileNameController = TextEditingController(text: widget.initialFileName ?? '');
  }

  @override
  void dispose() {
    // CORREÇÃO: Sempre descarte os controladores para evitar vazamento de memória
    _fileNameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processando Dados...')),
      );

      print("Arquivo: ${_fileNameController.text}");
      print("Tabela: ${_tableController.text}");
      print("Predefinida: $_isPredefined");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.assignment, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),

              // Campo: Nome do Arquivo
              TextFormField(
                controller: _fileNameController, // Nome corrigido aqui
                decoration: const InputDecoration(
                  labelText: 'Nome do Arquivo (.xlsx)',
                  prefixIcon: Icon(Icons.insert_drive_file),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obrigatório';
                  if (!value.toLowerCase().endsWith('.xlsx')) {
                    return 'Deve terminar com .xlsx';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Nome da Tabela
              TextFormField(
                controller: _tableController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Tabela',
                  prefixIcon: Icon(Icons.table_chart),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o nome da tabela';
                  return null;
                },
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text("Tabelas Predefinidas?"),
                secondary: const Icon(Icons.list_alt),
                value: _isPredefined,
                onChanged: (bool value) {
                  setState(() {
                    _isPredefined = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text("SALVAR FORMULÁRIO"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}