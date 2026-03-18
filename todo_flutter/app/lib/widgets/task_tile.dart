import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textStyle = task.isDone
        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
        : Theme.of(context).textTheme.bodyLarge;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (v) => onToggle(v ?? false),
        ),
        title: Text(task.title, style: textStyle),
        subtitle: Text(
          'Created ${MaterialLocalizations.of(context).formatShortDate(task.createdAt)}',
        ),
        trailing: IconButton(
          tooltip: 'Edit',
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
        onTap: () => onToggle(!task.isDone),
      ),
    );
  }
}

