import 'package:equatable/equatable.dart';
import '../../data/models/search_filter.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadLookupsEvent extends SearchEvent {
  const LoadLookupsEvent();
}

class SearchPropertiesEvent extends SearchEvent {
  final SearchFilter filter;

  const SearchPropertiesEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class UpdateFilterEvent extends SearchEvent {
  final SearchFilter filter;

  const UpdateFilterEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ResetFilterEvent extends SearchEvent {
  const ResetFilterEvent();
}

class LoadMorePropertiesEvent extends SearchEvent {
  const LoadMorePropertiesEvent();
}

class SaveRecentSearchEvent extends SearchEvent {
  final String? location;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  const SaveRecentSearchEvent({
    this.location,
    this.checkIn,
    this.checkOut,
    this.guests,
  });

  @override
  List<Object?> get props => [location, checkIn, checkOut, guests];
}

