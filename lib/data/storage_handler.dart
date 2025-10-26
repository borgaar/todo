import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todo/state/lists_state.dart';

final class StorageHandler {
  Future<File> get _storageFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_lists.json');
  }

  Future<void> save(final ListsLoaded state) async {
    final file = await _storageFile;
    await file.writeAsString(jsonEncode(state.toJson()));
  }

  Future<ListsLoaded> getStoredState() async {
    final file = await _storageFile;
    if (await file.exists()) {
      final content = await file.readAsString();
      return ListsLoaded.fromJsonString(content);
    }
    return ListsLoaded(lists: []);
  }
}
