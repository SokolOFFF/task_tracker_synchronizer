// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_sync.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TasksSync _$TasksSyncFromJson(Map<String, dynamic> json) {
  return _TasksSync.fromJson(json);
}

/// @nodoc
mixin _$TasksSync {
  @JsonKey(name: 'task_id_1')
  String get taskFromId => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id_2')
  String get taskToId => throw _privateConstructorUsedError;
  Map<String, Rule>? get fields => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TasksSyncCopyWith<TasksSync> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasksSyncCopyWith<$Res> {
  factory $TasksSyncCopyWith(TasksSync value, $Res Function(TasksSync) then) =
      _$TasksSyncCopyWithImpl<$Res, TasksSync>;
  @useResult
  $Res call(
      {@JsonKey(name: 'task_id_1') String taskFromId,
      @JsonKey(name: 'task_id_2') String taskToId,
      Map<String, Rule>? fields});
}

/// @nodoc
class _$TasksSyncCopyWithImpl<$Res, $Val extends TasksSync>
    implements $TasksSyncCopyWith<$Res> {
  _$TasksSyncCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskFromId = null,
    Object? taskToId = null,
    Object? fields = freezed,
  }) {
    return _then(_value.copyWith(
      taskFromId: null == taskFromId
          ? _value.taskFromId
          : taskFromId // ignore: cast_nullable_to_non_nullable
              as String,
      taskToId: null == taskToId
          ? _value.taskToId
          : taskToId // ignore: cast_nullable_to_non_nullable
              as String,
      fields: freezed == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as Map<String, Rule>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasksSyncImplCopyWith<$Res>
    implements $TasksSyncCopyWith<$Res> {
  factory _$$TasksSyncImplCopyWith(
          _$TasksSyncImpl value, $Res Function(_$TasksSyncImpl) then) =
      __$$TasksSyncImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'task_id_1') String taskFromId,
      @JsonKey(name: 'task_id_2') String taskToId,
      Map<String, Rule>? fields});
}

/// @nodoc
class __$$TasksSyncImplCopyWithImpl<$Res>
    extends _$TasksSyncCopyWithImpl<$Res, _$TasksSyncImpl>
    implements _$$TasksSyncImplCopyWith<$Res> {
  __$$TasksSyncImplCopyWithImpl(
      _$TasksSyncImpl _value, $Res Function(_$TasksSyncImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskFromId = null,
    Object? taskToId = null,
    Object? fields = freezed,
  }) {
    return _then(_$TasksSyncImpl(
      taskFromId: null == taskFromId
          ? _value.taskFromId
          : taskFromId // ignore: cast_nullable_to_non_nullable
              as String,
      taskToId: null == taskToId
          ? _value.taskToId
          : taskToId // ignore: cast_nullable_to_non_nullable
              as String,
      fields: freezed == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as Map<String, Rule>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasksSyncImpl implements _TasksSync {
  _$TasksSyncImpl(
      {@JsonKey(name: 'task_id_1') required this.taskFromId,
      @JsonKey(name: 'task_id_2') required this.taskToId,
      final Map<String, Rule>? fields})
      : _fields = fields;

  factory _$TasksSyncImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasksSyncImplFromJson(json);

  @override
  @JsonKey(name: 'task_id_1')
  final String taskFromId;
  @override
  @JsonKey(name: 'task_id_2')
  final String taskToId;
  final Map<String, Rule>? _fields;
  @override
  Map<String, Rule>? get fields {
    final value = _fields;
    if (value == null) return null;
    if (_fields is EqualUnmodifiableMapView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TasksSync(taskFromId: $taskFromId, taskToId: $taskToId, fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasksSyncImpl &&
            (identical(other.taskFromId, taskFromId) ||
                other.taskFromId == taskFromId) &&
            (identical(other.taskToId, taskToId) ||
                other.taskToId == taskToId) &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, taskFromId, taskToId,
      const DeepCollectionEquality().hash(_fields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TasksSyncImplCopyWith<_$TasksSyncImpl> get copyWith =>
      __$$TasksSyncImplCopyWithImpl<_$TasksSyncImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasksSyncImplToJson(
      this,
    );
  }
}

abstract class _TasksSync implements TasksSync {
  factory _TasksSync(
      {@JsonKey(name: 'task_id_1') required final String taskFromId,
      @JsonKey(name: 'task_id_2') required final String taskToId,
      final Map<String, Rule>? fields}) = _$TasksSyncImpl;

  factory _TasksSync.fromJson(Map<String, dynamic> json) =
      _$TasksSyncImpl.fromJson;

  @override
  @JsonKey(name: 'task_id_1')
  String get taskFromId;
  @override
  @JsonKey(name: 'task_id_2')
  String get taskToId;
  @override
  Map<String, Rule>? get fields;
  @override
  @JsonKey(ignore: true)
  _$$TasksSyncImplCopyWith<_$TasksSyncImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
