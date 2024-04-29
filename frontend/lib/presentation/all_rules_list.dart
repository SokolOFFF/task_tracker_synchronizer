import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/tasks_sync.dart';
import 'package:frontend/presentation/arrowed_texts.dart';
import 'package:frontend/presentation/cubits/rules_cubit.dart';
import 'package:frontend/presentation/cubits/selected_rule_cubit.dart';

class AllRulesList extends StatelessWidget {
  final List<TasksSync> rules;
  final void Function() addRule;

  const AllRulesList({
    super.key,
    required this.rules,
    required this.addRule,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            onPressed: context.read<RulesCubit>().loadRules,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          if (rules.isEmpty)
            Text(
              'No rules set',
              style: textTheme.bodyLarge,
            ),
          ...rules.indexed.map(
            (e) => BlocBuilder<SelectedRuleCubit, int?>(
              builder: (context, selectedRule) => Card(
                color: selectedRule == e.$1 ? Colors.white.withAlpha(24) : Colors.white.withAlpha(8),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.white.withAlpha(8),
                  onTap: () => context.read<SelectedRuleCubit>().select(e.$1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ArrowedTexts([e.$2.taskFromId, e.$2.taskToId]),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: addRule,
            child: Text(
              'Add rule',
              style: textTheme.bodyLarge,
            ),
          ),
        ]
            .expand(
              (element) => [element, const SizedBox(height: 8)],
            )
            .toList(),
      ),
    );
  }
}
