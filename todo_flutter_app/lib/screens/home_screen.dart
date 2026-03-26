import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../screens/calendar_screen.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as MyDateUtils;

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
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: _tasks[index].dueDate != null
            ? TimeOfDay.fromDateTime(_tasks[index].dueDate!)
            : TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _tasks[index] = _tasks[index].copyWith(
            dueDate: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'View Calendar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarScreen(tasks: _tasks),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: widget.onThemeChange,
            itemBuilder: (_) => AppTheme.themes.keys
                .map((theme) => PopupMenuItem(
                      value: theme,
                      child: Text(theme),
                    ))
                .toList(),
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