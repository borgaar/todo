import 'dart:convert';

import 'package:equatable/equatable.dart';

final class TodoListItem extends Equatable {
  final bool isChecked;
  final String id;
  final String description;

  const TodoListItem({
    required this.isChecked,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {'isChecked': isChecked, 'description': description, 'id': id};
  }

  factory TodoListItem.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return TodoListItem(
      isChecked: jsonData['isChecked'],
      description: jsonData['description'],
      id: jsonData['id'],
    );
  }

  TodoListItem copyWith({bool? isChecked, String? description}) {
    return TodoListItem(
      isChecked: isChecked ?? this.isChecked,
      description: description ?? this.description,
      id: id,
    );
  }

  @override
  List<Object?> get props => [isChecked, description];
}

final class TodoList extends Equatable {
  final String id;
  final String name;
  final List<TodoListItem> items;

  const TodoList({required this.id, required this.name, this.items = const []});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory TodoList.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    final itemsJson = jsonData['items'] as List<dynamic>;
    final items = itemsJson
        .map((item) => TodoListItem.fromJsonString(jsonEncode(item)))
        .toList();
    return TodoList(id: jsonData['id'], name: jsonData['name'], items: items);
  }

  TodoList copyWith({String? id, String? name, List<TodoListItem>? items}) {
    return TodoList(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, name, items];
}
