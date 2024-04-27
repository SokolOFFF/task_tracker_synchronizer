import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
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
                    update: _loadRules,
                    onTap: (i) => setState(() => _selectedRule = i),
                    addRule: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => SelectTasksScreen(api: widget.api),
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
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600,
                child: switch (_selectedRule) {
                  null => Text(
                      'Select a rule in the sidebar',
                      style: textTheme.headlineSmall?.copyWith(color: Colors.white54),
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
  final void Function() addRule;
  final void Function() update;
  final int? selected;
  const AllRulesList({
    super.key,
    required this.rules,
    required this.onTap,
    required this.addRule,
    required this.selected,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(onPressed: update, icon: const Icon(Icons.refresh)),
          const SizedBox(height: 16),
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
            : widget.api.checkYoutrackTaskId(_youtrackController.text.trim()).match(
                (error) => setState(() => _messageError = error),
                (exists) {
                  if (exists) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/addRules', arguments: {
                      'task_id_1': _youtrackController.text.trim(),
                      'task_id_2': _jiraController.text.trim(),
                    });
                    return;
                  }
                  setState(() => _messageError = 'Couldn\'t find a YouTrack issue');
                },
              ).run(),
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

sealed class Relation {
  const Relation();
}

class OneToOneRelation extends Relation {
  const OneToOneRelation();
}

class ComplexRelation extends Relation {
  final HashMap<String, String> relatinos;
  const ComplexRelation(this.relatinos);
}

class NotInclude extends Relation {
  const NotInclude();
}

enum RelationType { oneToOne, complex, notInclude }

class AddRulesScreen extends StatefulWidget {
  final Api api;
  const AddRulesScreen({super.key, required this.api});

  @override
  State<AddRulesScreen> createState() => _AddRulesScreenState();
}

class _AddRulesScreenState extends State<AddRulesScreen> {
  AsyncData<List<String>> _fields = const NoData();
  List<RelationType>? _ruleTypes;
  Map<String, Relation> _relations = {};
  ({String t1, String t2})? _tasksIds;

  @override
  void initState() {
    _loadFields();
    super.initState();
  }

  Future<void> _loadFields() async {
    setState(() => _fields = const LoadingData());
    final fields = await widget.api
        .getTaskFields()
        .match<AsyncData<List<String>>>(
          (error) => ErrorData(error),
          (d) => SomeData(d),
        )
        .run();
    setState(() {
      _ruleTypes = switch (fields) {
        SomeData(:final data) => data.map((e) => RelationType.notInclude).toList(),
        _ => null,
      };
      final relations = switch (fields) {
        SomeData(:final data) => Map<String, Relation>.fromEntries(
            data.map(
              (e) => MapEntry(e, const NotInclude()),
            ),
          ),
        _ => null,
      };
      if (relations != null) {
        _relations = relations;
      }
      _fields = fields;
    });
  }

  void _setRuleType(int fieldI, String name, RelationType? r) {
    final inputs = _ruleTypes;
    if (inputs != null && r != null && fieldI < inputs.length) {
      setState(() {
        inputs[fieldI] = r;
        _relations[name] = switch (r) {
          RelationType.notInclude => const NotInclude(),
          RelationType.oneToOne => const OneToOneRelation(),
          RelationType.complex => ComplexRelation(HashMap()),
        };
      });
      return;
    }
  }

  void _addRules() {
    final tasksIds = _tasksIds;
    if (tasksIds == null) return;
    final fields = _relations
        .map(
          (key, value) => MapEntry(
            key,
            switch (value) {
              OneToOneRelation _ => {'rule_type': 1},
              ComplexRelation(:final relatinos) => {'rule_type': 2, 'relations': relatinos},
              _ => null,
            },
          ),
        )
        .filter((value) => value != null);
    final rules = _relations.entries
        .map(
          (e) => {
            'task_id_1': tasksIds.t1,
            'task_id_2': tasksIds.t2,
            'fields': fields,
          },
        )
        .toList();
    widget.api
        .addRules(rules)
        .match(
          (l) => showDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'label',
            builder: (context) => SizedBox(
              width: 400,
              height: 400,
              child: Material(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(l),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          (r) => showDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'label',
            builder: (context) => SizedBox(
              width: 400,
              height: 400,
              child: Material(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          r ? 'Successfully added rules' : 'Couldn\'t add rules',
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (r) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .run();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _tasksIds = (
      t1: args['task_id_1'] as String,
      t2: args['task_id_2'] as String,
    );
    final textTheme = Theme.of(context).primaryTextTheme;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: switch (_fields) {
            ErrorData(:final message) => Text(
                message,
                style: textTheme.titleLarge?.copyWith(color: Colors.white54),
              ),
            SomeData(:final data) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('Enter rules', style: textTheme.titleLarge),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _addRules,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ...data.indexed
                        .map(
                          (e) {
                            final index = e.$1;
                            final selected = switch (_ruleTypes) {
                              List<RelationType> types => types[index],
                              null => RelationType.notInclude,
                            };
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(e.$2, style: textTheme.bodyLarge),
                                    const SizedBox(width: 16),
                                    Radio<RelationType>(
                                      value: RelationType.oneToOne,
                                      groupValue: selected,
                                      onChanged: (i) => _setRuleType(
                                        index,
                                        e.$2,
                                        i,
                                      ),
                                    ),
                                    const Text('1:1 relation'),
                                    const SizedBox(width: 16),
                                    Radio<RelationType>(
                                      value: RelationType.complex,
                                      groupValue: selected,
                                      onChanged: (i) => _setRuleType(
                                        index,
                                        e.$2,
                                        i,
                                      ),
                                    ),
                                    const Text('Match'),
                                  ],
                                ),
                                if (selected == RelationType.complex)
                                  RelationTypeConstructor(
                                    relations: _relations,
                                    relationsKey: e.$2,
                                  ),
                              ],
                            );
                          },
                        )
                        .expand((element) => [const Divider(), element])
                        .skip(1),
                  ],
                ),
              ),
            _ => const CircularProgressIndicator(),
          },
        ),
      ),
    );
  }
}

class RelationTypeConstructor extends StatefulWidget {
  final Map<String, Relation> relations;
  final String relationsKey;

  const RelationTypeConstructor({
    super.key,
    required this.relations,
    required this.relationsKey,
  });

  @override
  State<RelationTypeConstructor> createState() => _RelationTypeConstructorState();
}

class _RelationTypeConstructorState extends State<RelationTypeConstructor> {
  late final TextEditingController _input1;
  late final TextEditingController _input2;

  @override
  void initState() {
    _input1 = TextEditingController();
    _input2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _input1.dispose();
    _input2.dispose();
    super.dispose();
  }

  Relation? get _relations => widget.relations[widget.relationsKey];

  void _remove(String key) => setState(() {
        switch (_relations) {
          case ComplexRelation cr:
            cr.relatinos.remove(key);
            return;
          case _:
            return;
        }
      });

  void _save() {
    final text1 = _input1.text.trim();
    final text2 = _input2.text.trim();
    if (text1.isNotEmpty && text2.isNotEmpty) {
      setState(() {
        switch (_relations) {
          case ComplexRelation cr:
            cr.relatinos[text1] = text2;
            return;
          case _:
            return;
        }
      });
      _input1.clear();
      _input2.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...switch (_relations) {
          ComplexRelation(:final relatinos) => relatinos.entries.map(
              (e) => Row(
                children: [
                  ArrowedTexts([e.key, e.value]),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _remove(e.key),
                  ),
                ],
              ),
            ),
          _ => [],
        },
        Row(
          children: [
            SizedBox(
              width: 200,
              child: TextField(controller: _input1),
            ),
            const Icon(Icons.arrow_right_sharp),
            SizedBox(
              width: 200,
              child: TextField(controller: _input2),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _save,
            ),
          ],
        ),
      ],
    );
  }
}

class ArrowedTexts extends StatelessWidget {
  final List<String> texts;
  final TextStyle? style;
  final double? iconSize;
  final MainAxisAlignment? mainAxisAlignment;
  const ArrowedTexts(
    this.texts, {
    super.key,
    this.style,
    this.iconSize,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      children: texts
          .map(
            (e) => Text(
              e,
              style: style,
            ),
          )
          .expand((element) => [Icon(Icons.arrow_right_sharp, size: iconSize), element])
          .skip(1)
          .toList(),
    );
  }
}
