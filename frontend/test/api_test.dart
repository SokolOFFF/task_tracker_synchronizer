import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/api.dart';
import 'package:frontend/models/rule.dart';
import 'package:frontend/models/tasks_sync.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late Api api;
  late MockDio dio;

  setUp(() {
    dio = MockDio();
    api = Api(dio);
  });

  test('Check getRules with correct data', () async {
    when(dio.get(argThat(contains('rules')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{
          "TTD-1_KAN-1": <String, dynamic>{
            "task_id_1": "TTD-1",
            "task_id_2": "KAN-1",
            "fields": <String, dynamic>{
              "Summary": <String, dynamic>{"rule_type": 1},
              "Status": <String, dynamic>{
                "rule_type": 2,
                "relations": <String, String>{"TO DO": "To Do", "IN PROGRESS": "In Progress", "DONE": "Done"}
              }
            }
          },
          "LKA-2_PUI-3": <String, dynamic>{
            "task_id_1": "LKA-2",
            "task_id_2": "PUI-3",
            "fields": <String, dynamic>{
              "Summary": {"rule_type": 1},
              "Description": <String, dynamic>{
                "rule_type": 2,
                "relations": <String, String>{},
              }
            }
          },
        },
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.getRules().run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, [
          TasksSync(taskFromId: "TTD-1", taskToId: "KAN-1", fields: {
            'Summary': Rule(ruleType: 1),
            'Status': Rule(
              ruleType: 2,
              relations: {"TO DO": "To Do", "IN PROGRESS": "In Progress", "DONE": "Done"},
            ),
          }),
          TasksSync(taskFromId: "LKA-2", taskToId: "PUI-3", fields: {
            'Summary': Rule(ruleType: 1),
            'Description': Rule(
              ruleType: 2,
              relations: {},
            ),
          }),
        ]),
    };
  });

  test('Check getRules error', () async {
    when(dio.get(argThat(contains('rules')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'error': 'Not authorized', 'code': 401},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.getRules().run();
    expect(rules.isLeft(), true);
  });

  test('Check addRules with correct positive response', () async {
    when(dio.post(
      argThat(contains('rules')),
      data: anything,
    )).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'Success': true},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.addRules([]).run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, true),
    };
  });

  test('Check addRules with correct negative response', () async {
    when(dio.post(
      argThat(contains('rules')),
      data: anything,
    )).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'Success': false},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.addRules([]).run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, false),
    };
  });

  test('Check addRules with incorrect data', () async {
    when(dio.get(argThat(contains('rules')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'error': 'Not Authorized', 'code': 401},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.addRules([]).run();
    expect(rules.isLeft(), true);
  });

  test('Check getTaskFields with successful response', () async {
    when(dio.get(argThat(contains('task_fields')))).thenAnswer(
      (_) => Future.value(Response(
        data: ['a', 'b', 'c'],
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.getTaskFields().run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, ['a', 'b', 'c']),
    };
  });

  test('Check getTaskFields with error', () async {
    when(dio.get(argThat(contains('task_fields')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'error': 'Not Authorized', 'code': 401},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.getTaskFields().run();
    expect(rules.isLeft(), true);
  });

  test('Check checkAtlassianTaskId with positive response', () async {
    when(dio.get(argThat(contains('check_jira_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: true,
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkAtlassianTaskId('').run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, true),
    };
  });

  test('Check checkAtlassianTaskId with negative response', () async {
    when(dio.get(argThat(contains('check_jira_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: false,
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkAtlassianTaskId('').run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, false),
    };
  });

  test('Check checkAtlassianTaskId with error', () async {
    when(dio.get(argThat(contains('check_jira_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'error': 'Not Authorized', 'code': 401},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkAtlassianTaskId('').run();
    expect(rules.isLeft(), true);
  });

  test('Check checkYoutrackTaskId with positive response', () async {
    when(dio.get(argThat(contains('check_youtrack_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: true,
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkYoutrackTaskId('').run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, true),
    };
  });

  test('Check checkYoutrackTaskId with negative response', () async {
    when(dio.get(argThat(contains('check_youtrack_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: false,
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkYoutrackTaskId('').run();
    return switch (rules) {
      Left _ => fail('The returned value is left'),
      Right(:final value) => expect(value, false),
    };
  });

  test('Check checkYoutrackTaskId with error', () async {
    when(dio.get(argThat(contains('check_youtrack_issue')))).thenAnswer(
      (_) => Future.value(Response(
        data: <String, dynamic>{'error': 'Not Authorized', 'code': 401},
        requestOptions: RequestOptions(),
      )),
    );
    final rules = await api.checkYoutrackTaskId('').run();
    expect(rules.isLeft(), true);
  });
}
