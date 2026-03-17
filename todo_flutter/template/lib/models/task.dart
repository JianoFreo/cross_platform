import 'dart:convert';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isDone = false,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task copyWith({
    String? title,
    bool? isDone,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      isDone: (map['isDone'] as bool?) ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  static String encodeList(List<Task> tasks) {
    return jsonEncode(tasks.map((t) => t.toMap()).toList());
  }

  static List<Task> decodeList(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <Task>[];

    return decoded
        .whereType<Object?>()
        .map((e) => e is Map ? Map<String, dynamic>.from(e) : null)
        .whereType<Map<String, dynamic>>()
        .map(Task.fromMap)
        .toList(growable: false);
  }
}

