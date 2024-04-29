import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedRuleCubit extends Cubit<int?> {
  SelectedRuleCubit() : super(null);

  void select(int i) => emit(i);
  void deselect() => emit(null);
}
