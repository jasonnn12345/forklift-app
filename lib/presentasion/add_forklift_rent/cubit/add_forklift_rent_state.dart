part of 'add_forklift_rent_cubit.dart';

@immutable
sealed class AddRentState {}

final class AddRentInitial extends AddRentState {}

class AddRentLoading extends AddRentState {}

class AddRentSuccess extends AddRentState {
  final String message;

  AddRentSuccess({required this.message});
}

class AddRentError extends AddRentState {
  final String message;
  AddRentError({required this.message});
}