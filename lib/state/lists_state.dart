import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:todo/data/model/todo_list.dart';

abstract class ListsState extends Equatable {}

class ListOverviewInitial extends ListsState {
  @override
  List<Object?> get props => [];
}

class ListsLoading extends ListsState {
  @override
  List<Object?> get props => [];
}

class ListsLoaded extends ListsState {
  final List<TodoList> lists;

  ListsLoaded({required this.lists});

  TodoList getById(String id) {
    return lists.firstWhere((list) => list.id == id);
  }

  List<Map<String, dynamic>> toJson() {
    return lists.map((list) => list.toJson()).toList();
  }

  factory ListsLoaded.fromJsonString(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final lists = jsonData
        .map((item) => TodoList.fromJsonString(jsonEncode(item)))
        .toList();
    return ListsLoaded(lists: lists);
  }

  ListsLoaded copyWithItemToggled({
    required final String targetItemId,
    required final String listId,
  }) {
    final updatedLists = lists.map((list) {
      if (list.id != listId) return list;

      final updatedItems = list.items.map((item) {
        if (item.id != targetItemId) return item;
        return item.copyWith(isChecked: !item.isChecked);
      }).toList();

      return list.copyWith(items: updatedItems);
    }).toList();

    return ListsLoaded(lists: updatedLists);
  }

  @override
  List<Object?> get props => [lists];
}

class ListsError extends ListsState {
  final String message;

  ListsError({required this.message});

  @override
  List<Object?> get props => [message];
}
