import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/model/todo_list.dart';
import 'package:todo/data/storage_handler.dart';
import 'package:todo/state/lists_state.dart';
import 'package:uuid/uuid.dart';

final class ListsCubit extends Cubit<ListsState> {
  ListsCubit() : super(ListOverviewInitial());

  final _storageHandler = StorageHandler();

  @override
  Future<void> emit(final ListsState state) async {
    if (state is ListsLoaded) {
      await _storageHandler.save(state);
    }

    super.emit(state);
  }

  Future<void> initialize() async {
    emit(ListsLoading());

    final storedState = await _storageHandler.getStoredState();

    emit(storedState);
  }

  void renameItem({
    required final String targetItemId,
    required final String listId,
    required final String newDescription,
  }) {
    if (state is! ListsLoaded) return;

    final s = state as ListsLoaded;

    final updatedLists = s.lists.map((list) {
      if (list.id != listId) return list;

      final updatedItems = list.items.map((item) {
        if (item.id != targetItemId) return item;

        return item.copyWith(description: newDescription);
      }).toList();

      return list.copyWith(items: updatedItems);
    }).toList();

    emit(ListsLoaded(lists: updatedLists));
  }

  void renameList({
    required final String listId,
    required final String newName,
  }) {
    if (state is! ListsLoaded) return;

    final s = state as ListsLoaded;

    final updatedLists = s.lists.map((list) {
      if (list.id != listId) return list;

      return list.copyWith(name: newName);
    }).toList();

    emit(ListsLoaded(lists: updatedLists));
  }

  void removeList(String listId) {
    if (state is! ListsLoaded) return;

    final s = state as ListsLoaded;

    final updatedLists = s.lists.where((list) => list.id != listId).toList();

    emit(ListsLoaded(lists: updatedLists));
  }

  void removeItem({
    required final String targetItemId,
    required final String listId,
  }) {
    if (state is! ListsLoaded) return;

    final s = state as ListsLoaded;

    final updatedLists = s.lists.map((list) {
      if (list.id != listId) return list;

      final updatedItems = list.items
          .where((item) => item.id != targetItemId)
          .toList();

      return list.copyWith(items: updatedItems);
    }).toList();

    emit(ListsLoaded(lists: updatedLists));
  }

  void toggleItem({
    required final String targetItemId,
    required final String listId,
  }) {
    if (state is! ListsLoaded) return;

    final s = state as ListsLoaded;

    emit(s.copyWithItemToggled(targetItemId: targetItemId, listId: listId));
  }

  void addItem({
    required final String listId,
    required final String description,
  }) {
    if (state is! ListsLoaded) return;

    final newItem = TodoListItem(
      id: Uuid().v4(),
      description: description,
      isChecked: false,
    );

    final s = state as ListsLoaded;

    final list = s.lists.firstWhere((list) => list.id == listId);

    final updatedList = list.copyWith(items: [...list.items, newItem]);

    final updatedLists = s.lists
        .map((l) => l.id == listId ? updatedList : l)
        .toList();

    emit(ListsLoaded(lists: updatedLists));
  }

  void addList(String name) {
    if (state is! ListsLoaded) return;

    final newList = TodoList(id: Uuid().v4(), name: name, items: []);

    final s = state as ListsLoaded;

    emit(ListsLoaded(lists: [...s.lists, newList]));
  }
}
