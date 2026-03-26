class Task {
  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task copyWith({
    String? title,
    bool? isDone,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}