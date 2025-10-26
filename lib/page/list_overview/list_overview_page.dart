import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/page/widget/get_input_dialog.dart';
import 'package:todo/state/lists_cubit.dart';
import 'package:todo/state/lists_state.dart';
import 'package:todo/router/route_names.dart';

class ListOverviewPage extends StatelessWidget {
  const ListOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListsCubit, ListsState>(
      builder: (context, state) {
        if (state is! ListsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final cubit = context.read<ListsCubit>();
              final name = await showDialog<String?>(
                context: context,
                builder: (context) => GetInputDialog(title: "New List"),
              );
              if (name != null && name.trim().isNotEmpty) {
                cubit.addList(name.trim());
              }
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Todo Lists'),
            actions: [],
          ),
          body: SafeArea(
            child: state.lists.isEmpty
                ? Center(
                    child: Text(
                      'No lists available. Tap the + button to add a new list.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ...state.lists.map((list) {
                          return Dismissible(
                            key: Key(list.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              context.read<ListsCubit>().removeList(list.id);
                            },
                            child: ListTile(
                              title: Text(list.name),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.listDetail,
                                  pathParameters: {'listId': list.id},
                                );
                              },
                              onLongPress: () async {
                                final cubit = context.read<ListsCubit>();
                                final newName = await showDialog<String?>(
                                  context: context,
                                  builder: (context) => GetInputDialog(
                                    title: "Edit List",
                                    initialInput: list.name,
                                  ),
                                );
                                if (newName != null &&
                                    newName.trim().isNotEmpty) {
                                  cubit.renameList(
                                    listId: list.id,
                                    newName: newName.trim(),
                                  );
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
