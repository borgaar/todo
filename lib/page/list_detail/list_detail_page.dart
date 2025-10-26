import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/page/list_detail/widget/item_tile.dart';
import 'package:todo/page/list_detail/widget/new_item_text_field.dart';
import 'package:todo/state/lists_cubit.dart';
import 'package:todo/state/lists_state.dart';

class ListDetailPage extends StatelessWidget {
  const ListDetailPage(this._listId, {super.key});

  final String _listId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListsCubit, ListsState>(
      builder: (context, state) {
        if (state is! ListsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final list = state.getById(_listId)
          ..items.sort((a, b) => a.description.compareTo(b.description));

        final unchecked = list.items.where((item) => !item.isChecked);
        final checked = list.items.where((item) => item.isChecked);

        return Scaffold(
          appBar: AppBar(title: Text(list.name), centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: list.items.isEmpty
                      ? Center(
                          child: Text(
                            'No items in this list.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ...unchecked.map((item) {
                                return ItemTile(item: item, listId: _listId);
                              }),
                              if (checked.isNotEmpty && unchecked.isNotEmpty)
                                const Divider(),
                              ...checked.map((item) {
                                return ItemTile(item: item, listId: _listId);
                              }),
                            ],
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: NewItemTextField(
                    onSubmitted: (value) => context.read<ListsCubit>().addItem(
                      listId: _listId,
                      description: value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
