import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api.dart';
import 'package:frontend/models/tasks_sync.dart';
import 'package:frontend/presentation/models/async_data.dart';

class RulesCubit extends Cubit<AsyncData<List<TasksSync>>> {
  final Api api;

  RulesCubit(this.api) : super(const NoData());

  Future<void> loadRules() async {
    emit(const LoadingData());
    final rules = await api
        .getRules()
        .match<AsyncData<List<TasksSync>>>(
          (l) => ErrorData(l),
          (r) => SomeData(r),
        )
        .run();
    emit(rules);
  }
}
