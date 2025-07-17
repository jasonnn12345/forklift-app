part of 'item_type_index_cubit.dart';

@immutable
sealed class ItemTypeIndexState {}

final class ItemTypeIndexInitial extends ItemTypeIndexState {}

final class ItemTypeIndexLoaded extends ItemTypeIndexState {
  final List<ItemType> itemTypes;

  ItemTypeIndexLoaded({required this.itemTypes});

}

class ItemTypeIndexError extends ItemTypeIndexState {
  final String message;
  ItemTypeIndexError({required this.message});
}

class ItemTypeIndexLoading extends ItemTypeIndexState {}

