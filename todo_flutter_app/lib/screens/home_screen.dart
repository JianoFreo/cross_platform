import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasks') ?? '';
    setState(() => _tasks = Task.decodeList(raw));
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', Task.encodeList(_tasks));
  }

  Future<void> _addTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    DateTime? dueDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: text,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );

    setState(() {
      _tasks.insert(0, task);
      _controller.clear();
    });

    await _saveTasks();
  }

  Future<void> _toggleTask(Task task, bool value) async {
    final updatedTask = task.copyWith(isDone: value);
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = updatedTask;
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(Task task) async {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDarkMode
                          ? AppTheme.primaryColor
                          : Colors.blueAccent,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
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
                        final createdAt =
                            MyDateUtils.formatDateTime(task.createdAt);
                        final due = task.dueDate != null
                            ? 'Due: ${MyDateUtils.formatDate(task.dueDate!)}'
                            : '';
                        return TaskTile(
                          task: task,
                          onToggle: (v) => _toggleTask(task, v),
                          onDelete: () => _deleteTask(task),
                          subtitle: '$createdAt $due',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}