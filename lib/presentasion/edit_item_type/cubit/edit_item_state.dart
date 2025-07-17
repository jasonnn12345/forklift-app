part of 'edit_item_cubit.dart';

@immutable
sealed class EditItemState {}

class EditItemInitial extends EditItemState{}

class EditItemLoading extends EditItemState{}

class EditItemSuccess extends EditItemState{
  final String message;
  EditItemSuccess({required this.message});
}

class EditItemError extends EditItemState {
  final String message;
  EditItemError({required this.message});
}


