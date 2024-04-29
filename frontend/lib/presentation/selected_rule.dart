import 'package:flutter/material.dart';
import 'package:frontend/models/rule.dart';
import 'package:frontend/models/tasks_sync.dart';
import 'package:frontend/presentation/arrowed_texts.dart';

class SelectedRule extends StatelessWidget {
  final TasksSync rule;
  const SelectedRule({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ArrowedTexts(
          [rule.taskFromId, rule.taskToId],
          style: textTheme.displayLarge,
          iconSize: 36,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        ...switch (rule.fields) {
          null => [],
          Map<String, Rule> f => [
              const SizedBox(height: 16),
              ...f.entries
                  .map(
                    (e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(e.key, style: textTheme.titleLarge),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_back),
                        const SizedBox(width: 8),
                        if (e.value.ruleType == 1)
                          const Text('1:1 relation')
                        else
                          switch (e.value.relations) {
                            null => const Text('No relations'),
                            Map<String, String> m when m.isEmpty => const Text('No relations'),
                            Map<String, String> m => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: m.entries
                                    .map(
                                      (e) => ArrowedTexts([e.key, e.value]),
                                    )
                                    .toList(),
                              ),
                          },
                      ],
                    ),
                  )
                  .expand((element) => [const Divider(), element])
                  .skip(1),
            ],
        }
      ],
    );
  }
}
