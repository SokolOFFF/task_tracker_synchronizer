import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/models/rule.dart';
import 'package:frontend/models/tasks_sync.dart';

void main() {
  final api = Api();
  runApp(MyApp(api: api));
}

class MyApp extends StatelessWidget {
  final Api api;

  const MyApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (_) => AllRulesScreen(api: api),
          '/addRules': (_) => AddRulesScreen(api: api),
        },
      );
}

sealed class AsyncData<T> {
  const AsyncData();
}

class NoData<T> extends AsyncData<T> {
  const NoData();
}

class SomeData<T> extends AsyncData<T> {
  final T data;
  const SomeData(this.data);
}

class LoadingData<T> extends AsyncData<T> {
  const LoadingData();
}

class ErrorData<T> extends AsyncData<T> {
  final String message;
  const ErrorData(this.message);
}

class AllRulesScreen extends StatefulWidget {
  final Api api;

  const AllRulesScreen({super.key, required this.api});

  @override
  State<AllRulesScreen> createState() => _AllRulesScreenState();
}

class _AllRulesScreenState extends State<AllRulesScreen> {
  AsyncData<List<TasksSync>> _rules = const NoData();
  int? _selectedRule;

  @override
  void initState() {
    _loadRules();
    super.initState();
  }

  Future<void> _loadRules() async {
    setState(() => _rules = const LoadingData());
    final rules = await widget.api
        .getRules()
        .match<AsyncData<List<TasksSync>>>(
          (l) => ErrorData(l),
          (r) => SomeData(r),
        )
        .run();
    setState(() => _rules = rules);
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
              child: switch (_rules) {
                SomeData(:final data) => AllRulesList(
                    rules: data,
                    selected: _selectedRule,
                    onTap: (i) => setState(() => _selectedRule = i),
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
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600,
                child: switch (_selectedRule) {
                  null => const Text(
                      'Select a rule in the sidebar',
                      textAlign: TextAlign.center,
                    ),
                  int n => switch (_rules) {
                      SomeData(:final data) when n < data.length => SelectedRule(rule: data[n]),
                      _ => const CircularProgressIndicator(),
                    }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllRulesList extends StatelessWidget {
  final List<TasksSync> rules;
  final void Function(int i) onTap;
  final int? selected;
  const AllRulesList({
    super.key,
    required this.rules,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (rules.isEmpty)
            Text(
              'No rules set',
              style: textTheme.bodyLarge,
            ),
          ...rules.indexed.map(
            (e) => Card(
              color: selected == e.$1 ? Colors.white.withAlpha(24) : Colors.white.withAlpha(8),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.white.withAlpha(8),
                onTap: () => onTap(e.$1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ArrowedTexts([e.$2.taskFromId, e.$2.taskToId]),
                ),
              ),
            ),
          ),
        ]
            .expand(
              (element) => [element, const SizedBox(height: 16)],
            )
            .toList(),
      ),
    );
  }
}

class SelectedRule extends StatelessWidget {
  final TasksSync rule;
  const SelectedRule({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ArrowedTexts([rule.taskFromId, rule.taskToId], style: textTheme.displayLarge),
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

class SelectTasksScreen extends StatefulWidget {
  final Api api;
  const SelectTasksScreen({super.key, required this.api});

  @override
  State<SelectTasksScreen> createState() => _SelectTasksScreenState();
}

class _SelectTasksScreenState extends State<SelectTasksScreen> {
  late final TextEditingController _jiraController;
  late final TextEditingController _youtrackController;

  String? _messageError;

  @override
  void initState() {
    _jiraController = TextEditingController();
    _youtrackController = TextEditingController();
    super.initState();
  }

  Future<void> _checkTasks() => widget.api
      .checkAtlassianTaskId(_jiraController.text.trim())
      .match(
        (error) => setState(() => _messageError = error),
        (exists) => !exists
            ? setState(() => _messageError = 'Couldn\'t find a Jira issue')
            : widget.api
                .checkYoutrackTaskId(_youtrackController.text.trim())
                .match(
                  (error) => setState(() => _messageError = error),
                  (exists) => !exists
                      ? setState(() => _messageError = 'Couldn\'t find a YouTrack issue')
                      : Navigator.pushNamed(context, '/addRules'),
                )
                .run(),
      )
      .run();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final error = _messageError;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter issues\' IDs',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'YouTrack Issue ID:',
                style: textTheme.bodyMedium,
              ),
              TextField(
                controller: _youtrackController,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Jira Issue ID:',
                style: textTheme.bodyMedium,
              ),
              TextField(
                controller: _jiraController,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkTasks,
                child: Text(
                  'Continue',
                  style: textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 16),
              if (error != null)
                Text(
                  error,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddRulesScreen extends StatefulWidget {
  final Api api;
  const AddRulesScreen({super.key, required this.api});

  @override
  State<AddRulesScreen> createState() => _AddRulesScreenState();
}

class _AddRulesScreenState extends State<AddRulesScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter issues\' IDs',
                style: textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowedTexts extends StatelessWidget {
  final List<String> texts;
  final TextStyle? style;
  const ArrowedTexts(this.texts, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: texts
          .map(
            (e) => Text(
              e,
              style: style,
            ),
          )
          .expand((element) => [const Icon(Icons.arrow_right_sharp), element])
          .skip(1)
          .toList(),
    );
  }
}
