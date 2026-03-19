import 'package:flutter/material.dart';
import '../models/task.dart';
 
class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;
 
  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });
 
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: onChanged,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            decoration:
                task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}