// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TasksSyncImpl _$$TasksSyncImplFromJson(Map<String, dynamic> json) =>
    _$TasksSyncImpl(
      taskFromId: json['task_id_1'] as String,
      taskToId: json['task_id_2'] as String,
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Rule.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$TasksSyncImplToJson(_$TasksSyncImpl instance) =>
    <String, dynamic>{
      'task_id_1': instance.taskFromId,
      'task_id_2': instance.taskToId,
      'fields': instance.fields,
    };
