import 'package:go_router/go_router.dart';
import 'package:todo/page/list_detail/list_detail_page.dart';
import 'package:todo/page/list_overview/list_overview_page.dart';
import 'package:todo/router/route_names.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          path: "/",
          name: RouteNames.lists,
          builder: (context, state) => ListOverviewPage(),
          routes: [
            GoRoute(
              path: "/:listId",
              name: RouteNames.listDetail,
              builder: (context, state) {
                final listId = state.pathParameters['listId']!;
                return ListDetailPage(listId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
