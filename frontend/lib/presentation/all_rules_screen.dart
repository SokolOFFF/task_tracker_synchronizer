import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/tasks_sync.dart';
import 'package:frontend/presentation/all_rules_list.dart';
import 'package:frontend/presentation/cubits/rules_cubit.dart';
import 'package:frontend/presentation/cubits/selected_rule_cubit.dart';
import 'package:frontend/presentation/models/async_data.dart';
import 'package:frontend/presentation/selected_rule.dart';
import 'package:frontend/presentation/selected_task_screen.dart';

class AllRulesScreen extends StatefulWidget {
  const AllRulesScreen({super.key});

  @override
  State<AllRulesScreen> createState() => _AllRulesScreenState();
}

class _AllRulesScreenState extends State<AllRulesScreen> {
  @override
  void initState() {
    context.read<RulesCubit>().loadRules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<RulesCubit, AsyncData<List<TasksSync>>>(
                builder: (context, rules) => switch (rules) {
                  SomeData(:final data) => AllRulesList(
                      rules: data,
                      addRule: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => const SelectTasksScreen(),
                      ),
                    ),
                  ErrorData(:final message) => Center(
                      child: Text(
                        message,
                        style: textTheme.bodyLarge?.copyWith(color: Colors.red),
                      ),
                    ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600,
                child: BlocBuilder<SelectedRuleCubit, int?>(
                  builder: (context, selectedRule) => switch (selectedRule) {
                    null => Text(
                        'Select a rule in the sidebar',
                        style: textTheme.headlineSmall?.copyWith(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                    int n => BlocBuilder<RulesCubit, AsyncData<List<TasksSync>>>(
                        builder: (context, rules) => switch (rules) {
                          SomeData(:final data) when n < data.length => SelectedRule(rule: data[n]),
                          _ => const CircularProgressIndicator(),
                        },
                      ),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
