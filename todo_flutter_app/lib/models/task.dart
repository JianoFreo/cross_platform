import 'dart:convert';

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

  Task copyWith({String? title, bool? isDone, DateTime? dueDate}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }
}