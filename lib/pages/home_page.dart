import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list/models/task_model.dart';

// Widget do tipo StateFul, pois teremos diferents Estados na nossa tela
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variavel do tipo Lista de Tarefas,
  // que vai guarda nossas tarefas momentaneamene
  List<TaskModel> tasksList = [];

  // Controlador do campo de input de texto
  final TextEditingController taskTextEditingController = TextEditingController();

  // Variavel que vamos utilizar para execulta as acoes do SharedPreferences
  SharedPreferences? sharedPreferences; 
  
  // Funcao que e chamada sempre que nosso Widget e reconstruido
  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  // Inicializa o SharedPreferences para poder ser utilizado
  void initPrefs () async {
    sharedPreferences = await SharedPreferences.getInstance();
    readTasks();
  }

  // Salva a Lista inteira no LocalStorage
  void saveOnLocalStorage() {
    final taskData = tasksList.map((task) => task.toJson()).toList();
    sharedPreferences?.setStringList('tasks', taskData);
  }

  // CRUD

  // Funcao que adicina um novo intem na Lista
  void createTask({required TaskModel task}) {
    setState(() {
      tasksList.add(task);
      saveOnLocalStorage();
    });
  }

  // Funcao que resgata os valores salvos no LocalStorage e os coloca na Lista
  void readTasks() {
    setState(() {
      final taskData = sharedPreferences?.getStringList('tasks') ?? [];
      tasksList = taskData.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    });
  }

  // Atualiza uma Tarefa da Lista com base no seu ID
  void updateTask({required String taskId, required TaskModel updatedTask}) {
    final taskIndex = tasksList.indexWhere((task) => task.id == taskId);
    setState(() {
      tasksList[taskIndex] = updatedTask;
      saveOnLocalStorage();
    });
  }

  // Deleta uma Tarefa da Lista com case no seu ID
  void deleteTask({required String taskId}) {
    setState(() {
      tasksList.removeWhere((task) => task.id == taskId);
      saveOnLocalStorage();
    });
  }

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
        // Utilizacao de Operado Logico Ternario equivalente ao IF/ELSE
        child: tasksList.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListView.builder(
                        itemCount: tasksList.length,
                        itemBuilder: (context, index) {
                          final TaskModel task = tasksList[index];

                          return ListTile(
                            leading: Transform.scale(
                              scale: 2.0,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                value: task.isCompleted,
                                onChanged: (isChecked) {
                                  // Atualiza o estado da Tarefa ao marcar ou desmarcar o CheckBox
                                  final TaskModel updatedTask = task;
                                  updatedTask.isCompleted = isChecked!;
                                  updateTask(
                                    taskId: updatedTask.id,
                                    updatedTask: updatedTask,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                color: task.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 20,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // Deleta a Tarefa ao tocar no IconButton
                                deleteTask(taskId: task.id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 30.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Nenhuma tarefa cadastrada, toque no botao com o simbolo +',
                    textAlign: TextAlign.center,
                  ),
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
                content: TextField(
                  controller: taskTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Descreva sua tarefa',
                  ),
                  maxLines: 2,
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Adicia a Tarefa descrita no TextField a Lista, se o Campo de Texto nao estiver vazio
                      if (taskTextEditingController.text.isNotEmpty) {
                        final TaskModel newTask = TaskModel(
                          id: DateTime.now().toString(),
                          title: taskTextEditingController.text,
                        );

                        createTask(task: newTask);

                        // Limpa o Campo de Texto
                        taskTextEditingController.clear();

                        // Fecha o Dialog
                        Navigator.of(context).pop();
                      }
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
