part of 'database_cubit.dart';

class DatabaseState extends Equatable {
  String name;
  String surname;
  int age;

  DatabaseState({required this.name, required this.surname, required this.age});

  DatabaseState copyWith({String? name, String? surname, int? age}) {
    return DatabaseState(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        age: age ?? this.age);
  }

  @override
  List<Object?> get props => [name, surname, age];
}
