part of 'edit_forklift_cubit.dart';

@immutable
sealed class EditForkliftState {}

class EditForkliftInitial extends EditForkliftState{}

class EditForkliftLoading extends EditForkliftState{}

class EditForkliftSuccess extends EditForkliftState{
  final String message;
  EditForkliftSuccess({required this.message});
}

class EditForkliftError extends EditForkliftState {
  final String message;
  EditForkliftError({required this.message});
}


