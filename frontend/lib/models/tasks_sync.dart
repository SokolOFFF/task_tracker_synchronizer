import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/models/rule.dart';

part 'tasks_sync.freezed.dart';
part 'tasks_sync.g.dart';

@freezed
class TasksSync with _$TasksSync {
  factory TasksSync({
    @JsonKey(name: 'task_id_1') required String taskFromId,
    @JsonKey(name: 'task_id_2') required String taskToId,
    Map<String, Rule>? fields,
  }) = _TasksSync;

  factory TasksSync.fromJson(Map<String, dynamic> json) => _$TasksSyncFromJson(json);
}
