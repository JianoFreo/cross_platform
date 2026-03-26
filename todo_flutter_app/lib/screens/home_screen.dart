import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DBHelper.getTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    if (_controller.text.trim().isEmpty) return;

    DateTime? dueDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _controller.text.trim(),
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );

    await DBHelper.insertTask(task);
    _controller.clear();
    _loadTasks();
  }

  Future<void> _toggleTask(Task task, bool value) async {
    final updatedTask = task.copyWith(isDone: value);
    await DBHelper.updateTask(updatedTask);
    _loadTasks();
  }

  Future<void> _deleteTask(String id) async {
    await DBHelper.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Add a task',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _tasks.isEmpty
                    ? const Center(child: Text('No tasks yet'))
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          final createdAt = DateUtils.formatDateTime(task.createdAt);
                          final due = task.dueDate != null
                              ? 'Due: ${DateUtils.formatDate(task.dueDate!)}'
                              : '';
                          return TaskTile(
                            task: task,
                            onToggle: (v) => _toggleTask(task, v),
                            onDelete: () => _deleteTask(task.id),
                            subtitle: '$createdAt $due',
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}