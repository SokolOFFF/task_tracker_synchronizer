import 'package:flutter/material.dart';
import 'package:frontend/api.dart';

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
          '/': (_) => SelectTasksScreen(api: api),
          '/addRules': (_) => AddRulesScreen(api: api),
        },
      );
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
