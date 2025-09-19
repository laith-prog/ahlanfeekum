import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

class ToggleFavoriteEvent extends HomeEvent {
  final String propertyId;

  const ToggleFavoriteEvent({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}
