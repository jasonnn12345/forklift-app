part of 'renter_index_cubit.dart';

@immutable
sealed class RenterIndexState {}

final class RenterIndexInitial extends RenterIndexState {}

final class RenterIndexLoading extends RenterIndexState {}

final class RenterIndexLoaded extends RenterIndexState {
  final List<RenterData> renterList;
  RenterIndexLoaded({required this.renterList});
}

final class RenterIndexError extends RenterIndexState {
  final String message;
  RenterIndexError({required this.message});
}

// Tambahan state untuk create (tambah penyewaan)
final class AddRenterSuccess extends RenterIndexState {
  final String message;
  AddRenterSuccess({required this.message});
}

final class AddRenterError extends RenterIndexState {
  final String message;
  AddRenterError({required this.message});
}
