import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:frontend/api.dart';
import 'package:frontend/presentation/models/async_data.dart';
import 'package:frontend/presentation/models/relation.dart';
import 'package:frontend/presentation/relation_type_contructor.dart';

class AddRulesScreen extends StatefulWidget {
  const AddRulesScreen({super.key});

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
    final fields = await context.read<Api>()
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
    context.read<Api>()
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
