import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class Todo {
  String title;
  String content;
  bool done;

  Todo({required this.title, required this.content, this.done = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];

  void _addTodo(String title, String content) {
    setState(() {
      todos.add(Todo(title: title, content: content));
    });
  }

  void _showAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTodoScreen(onAdd: _addTodo),
      ),
    );
  }

  void _delete(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _toggle(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo")),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Card(
            child: ListTile(
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration:
                      todo.done ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(todo.content),
              leading: Checkbox(
                value: todo.done,
                onChanged: (_) => _toggle(index),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _delete(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  final Function(String, String) onAdd;

  const AddTodoScreen({super.key, required this.onAdd});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void _save() {
    if (titleController.text.isEmpty) return;

    widget.onAdd(titleController.text, contentController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Todo"),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
          ],
        ),
      ),
    );
  }
}