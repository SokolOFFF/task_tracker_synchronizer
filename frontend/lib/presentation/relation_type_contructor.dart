import 'package:flutter/material.dart';
import 'package:frontend/presentation/arrowed_texts.dart';
import 'package:frontend/presentation/models/relation.dart';

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
