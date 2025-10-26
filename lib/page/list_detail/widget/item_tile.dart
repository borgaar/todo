import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/model/todo_list.dart';
import 'package:todo/page/widget/get_input_dialog.dart';
import 'package:todo/state/lists_cubit.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required TodoListItem item,
    required String listId,
  }) : _item = item,
       _listId = listId;

  final TodoListItem _item;
  final String _listId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: AlignmentGeometry.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      key: Key(_item.id),
      onDismissed: (direction) => context.read<ListsCubit>().removeItem(
        targetItemId: _item.id,
        listId: _listId,
      ),
      child: ListTile(
        onTap: () => context.read<ListsCubit>().toggleItem(
          targetItemId: _item.id,
          listId: _listId,
        ),
        onLongPress: () async {
          final cubit = context.read<ListsCubit>();
          final newDescription = await showDialog<String?>(
            context: context,
            builder: (context) => GetInputDialog(
              title: "Edit Item",
              initialInput: _item.description,
            ),
          );
          if (newDescription != null && newDescription.trim().isNotEmpty) {
            cubit.renameItem(
              targetItemId: _item.id,
              listId: _listId,
              newDescription: newDescription.trim(),
            );
          }
        },
        leading: Checkbox(
          value: _item.isChecked,
          onChanged: (value) {
            context.read<ListsCubit>().toggleItem(
              targetItemId: _item.id,
              listId: _listId,
            );
          },
        ),
        title: Text(
          _item.description,
          style: TextStyle(
            decoration: _item.isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}
