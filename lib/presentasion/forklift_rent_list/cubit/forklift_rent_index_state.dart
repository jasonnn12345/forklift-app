part of 'forklift_rent_index_cubit.dart';

@immutable
sealed class ForkliftRentIndexState {}

final class ForkliftRentIndexInitial extends ForkliftRentIndexState {}

final class ForkliftRentIndexLoaded extends ForkliftRentIndexState {
  final List<ForkliftRentData> forkliftRent;
  ForkliftRentIndexLoaded({required this.forkliftRent});
}

final class ForkliftRentIndexError extends ForkliftRentIndexState {
  final String message;
  ForkliftRentIndexError({required this.message});
}

final class ForkliftRentIndexLoading extends ForkliftRentIndexState {}


