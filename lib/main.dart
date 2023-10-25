import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: TaskApp(),
  ));
}

class Task {
  final String id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});

  // Factory method to create Task object from JSON data
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'] ?? "",
      completed: json['completed'] ?? false,
    );
  }
}

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  // Fetch tasks from the server
  Future<void> fetchTasks() async {
    final Uri url = Uri.parse('http://localhost:3000/todolist/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> tasksData = json.decode(response.body);
      setState(() {
        tasks = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
      });
    } else {
      print("Error getting the list of tasks. Code of the error is : ${response.statusCode}");
    }
  }

  // Add a new task
  Future<void> addTask(String title) async {
    final Uri url = Uri.parse('http://localhost:3000/todolist/tasks');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'title': title}),
    );

    if (response.statusCode == 200) {
      taskController.clear();
      fetchTasks();
    } else {
      print("Error adding new task with the title $title. Code of the error is : ${response.statusCode}");
    }
  }

  // Mark a task as completed
  Future<void> completeTask(Task task) async {
    final Uri url = Uri.parse('http://localhost:3000/todolist/tasks/${task.id}');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'completed': true.toString()}),
    );

    if (response.statusCode == 200) {
      fetchTasks();
    } else {
      print("Error marking the task with the id ${task.id} as completed. Code of the error is : ${response.statusCode}");
    }
  }

  // Delete a task
  Future<void> deleteTask(Task task) async {
    final Uri url = Uri.parse('http://localhost:3000/todolist/tasks/${task.id}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      tasks.remove(task);
      fetchTasks();
    } else {
      print("Error deleting task with ID ${task.id}. Code of the error is: ${response.statusCode}");
    }
  }

  // Show a dialog to add a new task
  Future<void> _showAddTaskDialog() async {
    String newTaskTitle = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nouvelle tâche'),
          content: TextField(
            onChanged: (value) {
              newTaskTitle = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                addTask(newTaskTitle);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de tâches'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Build the task list
  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  // Build a task item
  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      onDismissed: (direction) {
        _showDeleteConfirmationDialog(task);
      },
      child: ListTile(
        title: Text(task.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task.completed,
              onChanged: (bool? completed) {
                completeTask(task);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show a confirmation dialog for task deletion
  Future<void> _showDeleteConfirmationDialog(Task task) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer cette tâche ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteTask(task);
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
          ],
        );
      },
    );
  }
}
