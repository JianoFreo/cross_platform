import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
// Alias your utils import to avoid conflict with Flutter's DateUtils
import '../utils/date_utils.dart' as MyDateUtils;
import '../theme/app_theme.dart'; // <--- ADD THIS

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  final String currentTheme;
  final ValueChanged<String> onThemeChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _tasks.add(Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: text,
        createdAt: DateTime.now(),
      ));
      _controller.clear();
    });
  }

  void _toggle(int index, bool value) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isDone: value);
    });
  }

  void _delete(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editDueDate(int index) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _tasks[index].dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _tasks[index] = _tasks[index].copyWith(dueDate: selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: widget.onThemeChange,
            itemBuilder: (_) => MyDateUtilsAppThemeFix(), // FIXED BELOW
          ),
        ],
      ),
      body: Column(
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
                      return TaskTile(
                        task: task,
                        onToggle: (v) => _toggle(index, v),
                        onDelete: () => _delete(index),
                        onEdit: () => _editDueDate(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Helper for theme selection menu
List<PopupMenuEntry<String>> MyDateUtilsAppThemeFix() {
  return AppTheme.themes.keys
      .map((theme) => PopupMenuItem(
            value: theme,
            child: Text(theme),
          ))
      .toList();
}