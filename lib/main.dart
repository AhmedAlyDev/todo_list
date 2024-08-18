import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum TextError { exists, length, none }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _tasks = [];
  final List<bool> _completed = [];
  final TextEditingController _taskController = TextEditingController();
  TextError _textError = TextError.none;

  void _validateTask(String task) {
    if (task.isEmpty || task.length < 4) {
      setState(() {
        _textError = TextError.length;
      });
      return;
    } else if (_tasks.contains(task)) {
      setState(() {
        _textError = TextError.exists;
      });
      return;
    }
    setState(() {
      _textError = TextError.none;
    });
  }

  void _addTask() {
    final task = _taskController.text;
    _validateTask(task);

    if (_textError == TextError.none) {
      setState(() {
        _tasks.add(task);
        _completed.add(false);
        _taskController.clear();
      });
    }
  }

  void _removeCompletedTasks() {
    setState(() {
      for (int i = _completed.length - 1; i >= 0; i--) {
        if (_completed[i]) {
          _tasks.removeAt(i);
          _completed.removeAt(i);
        }
      }
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _removeCompletedTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Add a new task',
                      errorText: _getErrorMessage(),
                    ),
                    onChanged: (text) => _clearError(),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _completed[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _completed[index] = value ?? false;
                      });
                    },
                  ),
                  title: Text(_tasks[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clearError() {
    setState(() {
      _textError = TextError.none;
    });
  }

  String? _getErrorMessage() {
    switch (_textError) {
      case TextError.exists:
        return "Task already exists";
      case TextError.length:
        return "Task should be at least 4 characters long";
      case TextError.none:
      default:
        return null;
    }
  }
}
