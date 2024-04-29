import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api.dart';

class SelectTasksScreen extends StatefulWidget {
  const SelectTasksScreen({super.key});

  @override
  State<SelectTasksScreen> createState() => _SelectTasksScreenState();
}

class _SelectTasksScreenState extends State<SelectTasksScreen> {
  late final TextEditingController _jiraController;
  late final TextEditingController _youtrackController;
  late final Api _api;

  String? _messageError;

  @override
  void initState() {
    _api = context.read<Api>();
    _jiraController = TextEditingController();
    _youtrackController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _jiraController.dispose();
    _youtrackController.dispose();
    super.dispose();
  }

  Future<void> _checkTasks() => _api
      .checkAtlassianTaskId(_jiraController.text.trim())
      .match(
        (error) => setState(() => _messageError = error),
        (exists) => !exists
            ? setState(() => _messageError = 'Couldn\'t find a Jira issue')
            : _api.checkYoutrackTaskId(_youtrackController.text.trim()).match(
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
