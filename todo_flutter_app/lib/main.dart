import 'dart:convert';

class Task {
  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
  });

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
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }

  static String encodeList(List<Task> tasks) =>
      jsonEncode(tasks.map((t) => t.toMap()).toList());

  static List<Task> decodeList(String raw) {
    if (raw.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}