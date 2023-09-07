import 'dart:convert';

// Classe que sera o Modelo para um Objeto Tarefa
class TaskModel {

  final String id;
  String title;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  @override
  String toString() => 'TaskModel(id: $id, title: $title, isCompleted: $isCompleted)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
