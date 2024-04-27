import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/models/tasks_sync.dart';

class Api {
  final _dio = Dio();
  final _localServer = 'http://127.0.0.1:8000';

  TaskEither<String, List<TasksSync>> getRules() => TaskEither.tryCatch(
        () async {
          final result = await _dio.get('$_localServer/rules/');
          final rules = result.data as Map<String, dynamic>;
          return rules.values.map((e) => TasksSync.fromJson(e as Map<String, dynamic>)).toList();
        },
        (error, _) => '$error',
      );

  TaskEither<String, bool> addRule() => TaskEither.tryCatch(
        () async {
          final result = await _dio.post('$_localServer/rule/');
          final data = result.data as Map<String, dynamic>;
          return data['Success'] as bool;
        },
        (error, _) => '$error',
      );

  TaskEither<String, List<String>> getTaskFields() => TaskEither.tryCatch(
        () async {
          final result = await _dio.get('$_localServer/task_fields/');
          final list = result.data as List;
          return list.map((e) => e as String).toList();
        },
        (error, _) => '$error',
      );

  TaskEither<String, bool> checkAtlassianTaskId(String taskId) => TaskEither.tryCatch(
        () async {
          final result = await _dio.get('$_localServer/check_jira_issue/$taskId/');
          final task = result.data;
          return task as bool;
        },
        (error, _) => '$error',
      );

  TaskEither<String, bool> checkYoutrackTaskId(String taskId) => TaskEither.tryCatch(
        () async {
          final result = await _dio.get('$_localServer/check_youtrack_issue/$taskId/');
          final task = result.data;
          return task as bool;
        },
        (error, _) => '$error',
      );
}
