part of 'add_item_cubit.dart';

@immutable
sealed class AddItemState {}

final class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {
  final String message;

  AddItemSuccess({required this.message});

}

class AddItemError extends AddItemState {
  final String message;


  AddItemError({required this.message});
}
