// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Rule _$RuleFromJson(Map<String, dynamic> json) {
  return _Rule.fromJson(json);
}

/// @nodoc
mixin _$Rule {
  @JsonKey(name: 'rule_type')
  int get ruleType => throw _privateConstructorUsedError;
  Map<String, String>? get relations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RuleCopyWith<Rule> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RuleCopyWith<$Res> {
  factory $RuleCopyWith(Rule value, $Res Function(Rule) then) =
      _$RuleCopyWithImpl<$Res, Rule>;
  @useResult
  $Res call(
      {@JsonKey(name: 'rule_type') int ruleType,
      Map<String, String>? relations});
}

/// @nodoc
class _$RuleCopyWithImpl<$Res, $Val extends Rule>
    implements $RuleCopyWith<$Res> {
  _$RuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleType = null,
    Object? relations = freezed,
  }) {
    return _then(_value.copyWith(
      ruleType: null == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as int,
      relations: freezed == relations
          ? _value.relations
          : relations // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RuleImplCopyWith<$Res> implements $RuleCopyWith<$Res> {
  factory _$$RuleImplCopyWith(
          _$RuleImpl value, $Res Function(_$RuleImpl) then) =
      __$$RuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'rule_type') int ruleType,
      Map<String, String>? relations});
}

/// @nodoc
class __$$RuleImplCopyWithImpl<$Res>
    extends _$RuleCopyWithImpl<$Res, _$RuleImpl>
    implements _$$RuleImplCopyWith<$Res> {
  __$$RuleImplCopyWithImpl(_$RuleImpl _value, $Res Function(_$RuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleType = null,
    Object? relations = freezed,
  }) {
    return _then(_$RuleImpl(
      ruleType: null == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as int,
      relations: freezed == relations
          ? _value._relations
          : relations // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RuleImpl implements _Rule {
  _$RuleImpl(
      {@JsonKey(name: 'rule_type') required this.ruleType,
      final Map<String, String>? relations})
      : _relations = relations;

  factory _$RuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RuleImplFromJson(json);

  @override
  @JsonKey(name: 'rule_type')
  final int ruleType;
  final Map<String, String>? _relations;
  @override
  Map<String, String>? get relations {
    final value = _relations;
    if (value == null) return null;
    if (_relations is EqualUnmodifiableMapView) return _relations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Rule(ruleType: $ruleType, relations: $relations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RuleImpl &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            const DeepCollectionEquality()
                .equals(other._relations, _relations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, ruleType, const DeepCollectionEquality().hash(_relations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RuleImplCopyWith<_$RuleImpl> get copyWith =>
      __$$RuleImplCopyWithImpl<_$RuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RuleImplToJson(
      this,
    );
  }
}

abstract class _Rule implements Rule {
  factory _Rule(
      {@JsonKey(name: 'rule_type') required final int ruleType,
      final Map<String, String>? relations}) = _$RuleImpl;

  factory _Rule.fromJson(Map<String, dynamic> json) = _$RuleImpl.fromJson;

  @override
  @JsonKey(name: 'rule_type')
  int get ruleType;
  @override
  Map<String, String>? get relations;
  @override
  @JsonKey(ignore: true)
  _$$RuleImplCopyWith<_$RuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
