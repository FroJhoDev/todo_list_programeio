import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';

// Widget do tipo StateFul, pois teremos diferents Estados na nossa tela
class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Variavel do tipo Lista de Tarefas, que vai guarda nossas tarefas momentaneamene
  List<TaskModel> tasksList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Lista de Tarefssas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Funcao que exibe um Dialogo/Modal
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nova Tarefa'),
                content: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Descreva sua tarefa',
                  ),
                  maxLines: 2,
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      // Aqui vai ficar a funcao de fechar o modal
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Aqui vai ficar a funcao de salvar uma nova tarefa
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
