part of 'forklift_index_cubit.dart';

@immutable
sealed class ForkliftIndexState {}

final class ForkliftIndexInitial extends ForkliftIndexState {}

final class ForkliftIndexLoaded extends ForkliftIndexState {
  final List<ForkliftData> forklifts;

  ForkliftIndexLoaded({required this.forklifts});
}

final class ForkliftIndexError extends ForkliftIndexState {
  final String message;
  ForkliftIndexError({required this.message});
}

final class ForkliftIndexLoading extends ForkliftIndexState {}


