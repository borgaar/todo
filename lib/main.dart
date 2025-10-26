import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/router/router.dart';
import 'package:todo/state/lists_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListsCubit()..initialize(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Todo',
        routerConfig: router,
      ),
    );
  }
}
