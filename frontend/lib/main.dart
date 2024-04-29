import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api.dart';
import 'package:frontend/presentation/add_rules_screen.dart';
import 'package:frontend/presentation/all_rules_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (_) => Dio(),
        ),
        RepositoryProvider(
          create: (ctx) => Api(
            ctx.read<Dio>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (_) => const AllRulesScreen(),
          '/addRules': (_) => const AddRulesScreen(),
        },
      );
}
