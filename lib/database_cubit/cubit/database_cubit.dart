import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit()
      : super(
          DatabaseState(
            name: "",
            surname: "",
            age: 0,
          ),
        );

  changename(String name) {
    emit(
      state.copyWith(name: name),
    );
  }
}
