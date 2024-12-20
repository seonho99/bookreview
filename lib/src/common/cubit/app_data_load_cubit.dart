import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../enum/common_state_status.dart';

class AppDataLoadCubit extends Cubit<AppDataLoadState> {
  AppDataLoadCubit() : super(AppDataLoadState()) {
    _loadData();
  }

  void _loadData() async {
    emit(state.copyWith(status: CommonStateStatus.loading));
    await Future.delayed(Duration(milliseconds: 1000));
    emit(state.copyWith(status: CommonStateStatus.loaded));

  }
}

class AppDataLoadState extends Equatable {
  final CommonStateStatus status;

  AppDataLoadState({this.status = CommonStateStatus.init});

  copyWith({
    CommonStateStatus? status,
  }) {
    return AppDataLoadState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
