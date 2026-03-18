import 'dart:math';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_tile.dart';

enum TaskFilter { all, active, completed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = <Task>[];
  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _sortTasks();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  List<Task> get _visibleTasks {
    return switch (_filter) {
      TaskFilter.all => _tasks,
      TaskFilter.active => _tasks.where((t) => !t.isDone).toList(growable: false),
      TaskFilter.completed => _tasks.where((t) => t.isDone).toList(growable: false),
    };
  }

  int get _activeCount => _tasks.where((t) => !t.isDone).length;

  String _newId() {
    // Avoid Random.secure() to keep web support simple.
    final rand = Random();
    final now = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final tail = List<int>.generate(8, (_) => rand.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return '$now-$tail';
  }

  Future<String?> _showEditor({
    required String title,
    required String confirmLabel,
    String? initialText,
  }) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final controller = TextEditingController(text: initialText ?? '');
        String? errorText;

        void submit(StateSetter setSheetState) {
          final text = controller.text.trim();
          if (text.isEmpty) {
            setSheetState(() => errorText = 'Please enter a task');
            return;
          }
          Navigator.of(ctx).pop(text);
        }

        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(title, style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submit(setSheetState),
                    decoration: InputDecoration(
                      labelText: 'Task',
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => submit(setSheetState),
                    child: Text(confirmLabel),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addTask() async {
    final text = await _showEditor(title: 'New task', confirmLabel: 'Add');
    if (text == null) return;

    setState(() {
      _tasks.add(
        Task(
          id: _newId(),
          title: text,
          createdAt: DateTime.now(),
        ),
      );
      _sortTasks();
    });
  }

  Future<void> _editTask(Task task) async {
    final text = await _showEditor(
      title: 'Edit task',
      confirmLabel: 'Save',
      initialText: task.title,
    );
    if (text == null) return;

    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) _tasks[idx] = _tasks[idx].copyWith(title: text);
      _sortTasks();
    });
  }

  Future<void> _toggleTask(Task task, bool isDone) async {
    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) _tasks[idx] = _tasks[idx].copyWith(isDone: isDone);
      _sortTasks();
    });
  }

  Future<void> _deleteTask(Task task) async {
    final removedIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (removedIndex == -1) return;

    setState(() {
      _tasks.removeAt(removedIndex);
    });

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              _tasks.insert(removedIndex, task);
              _sortTasks();
            });
          },
        ),
      ),
    );
  }

  Future<void> _clearCompleted() async {
    final completed = _tasks.where((t) => t.isDone).toList(growable: false);
    if (completed.isEmpty) return;

    setState(() {
      _tasks.removeWhere((t) => t.isDone);
    });

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Cleared ${completed.length} completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              _tasks.addAll(completed);
              _sortTasks();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleTasks;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<TaskFilter>(
            tooltip: 'Filter',
            initialValue: _filter,
            onSelected: (f) => setState(() => _filter = f),
            itemBuilder: (context) => const [
              PopupMenuItem(value: TaskFilter.all, child: Text('All')),
              PopupMenuItem(value: TaskFilter.active, child: Text('Active')),
              PopupMenuItem(value: TaskFilter.completed, child: Text('Completed')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: (v) {
              if (v == 'clear_completed') _clearCompleted();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'clear_completed',
                child: Text('Clear completed'),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$_activeCount active',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SegmentedButton<TaskFilter>(
                    segments: const [
                      ButtonSegment(value: TaskFilter.all, label: Text('All')),
                      ButtonSegment(
                        value: TaskFilter.active,
                        label: Text('Active'),
                      ),
                      ButtonSegment(
                        value: TaskFilter.completed,
                        label: Text('Done'),
                      ),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (s) => setState(() => _filter = s.first),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.checklist, size: 64, color: scheme.primary),
                            const SizedBox(height: 12),
                            Text(
                              _tasks.isEmpty
                                  ? 'Add your first task'
                                  : 'No tasks in this filter',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: _addTask,
                              icon: const Icon(Icons.add),
                              label: const Text('Add task'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final task = visible[index];
                        return TaskTile(
                          task: task,
                          onToggle: (v) => _toggleTask(task, v),
                          onEdit: () => _editTask(task),
                          onDelete: () => _deleteTask(task),
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

