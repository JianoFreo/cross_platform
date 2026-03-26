import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../utils/date_utils.dart';

typedef ThemeCallback = void Function(String themeName);

class HomeScreen extends StatefulWidget {
  final ThemeCallback? onThemeChange;
  const HomeScreen({super.key, this.onThemeChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  String _currentTheme = 'Blue';

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

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _tasks.insert(0, task);
      _controller.clear();
    });

    await _saveTasks();
  }

  Future<void> _editTaskDueDate(Task task) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: task.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    final updated = task.copyWith(dueDate: picked);
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = updated;
    });

    await _saveTasks();
  }

  Future<void> _toggleTask(Task task, bool value) async {
    final updated = task.copyWith(isDone: value);
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = updated;
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(Task task) async {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
    await _saveTasks();
  }

  void _changeTheme(String theme) {
    setState(() => _currentTheme = theme);
    if (widget.onThemeChange != null) widget.onThemeChange!(theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeTheme,
            itemBuilder: (context) => [
              'Blue', 'Green', 'Yellow', 'Red', 'Brown', 'Dark'
            ].map((theme) => PopupMenuItem(
              value: theme,
              child: Text(theme),
            )).toList(),
            icon: const Icon(Icons.palette),
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
                        final createdAt = MyDateUtils.formatDateTime(task.createdAt);
                        final due = task.dueDate != null
                            ? 'Due: ${MyDateUtils.formatDate(task.dueDate!)}'
                            : '';
                        return TaskTile(
                          task: task,
                          onToggle: (v) => _toggleTask(task, v),
                          onDelete: () => _deleteTask(task),
                          onEdit: () => _editTaskDueDate(task),
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