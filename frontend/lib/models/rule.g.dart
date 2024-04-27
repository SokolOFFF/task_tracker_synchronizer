// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RuleImpl _$$RuleImplFromJson(Map<String, dynamic> json) => _$RuleImpl(
      ruleType: (json['rule_type'] as num).toInt(),
      relations: (json['relations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$RuleImplToJson(_$RuleImpl instance) =>
    <String, dynamic>{
      'rule_type': instance.ruleType,
      'relations': instance.relations,
    };
