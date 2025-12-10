enum Priority { high, medium, low }

enum Category { work, personal, shopping, health, other }

class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  Category category;
  bool isCompleted;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.category = Category.personal,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'priority': priority.index,
    'category': category.index,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    priority: Priority.values[json['priority'] ?? 1],
    category: Category.values[json['category'] ?? 1],
    isCompleted: json['isCompleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
  );

  String get priorityText =>
      priority.name[0].toUpperCase() + priority.name.substring(1);
  String get categoryText =>
      category.name[0].toUpperCase() + category.name.substring(1);
}
