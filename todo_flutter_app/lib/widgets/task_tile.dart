import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.subtitle,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isDone,
        onChanged: (v) => onToggle(v ?? false),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: IconButton(
        tooltip: 'Delete',
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
      onTap: () => onToggle(!task.isDone),
    );
  }
}