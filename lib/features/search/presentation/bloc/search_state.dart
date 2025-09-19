import 'package:equatable/equatable.dart';
import '../../domain/entities/search_entities.dart';
import '../../data/models/search_filter.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class LookupsLoading extends SearchState {
  const LookupsLoading();
}

class LookupsLoaded extends SearchState {
  final List<LookupItemEntity> propertyTypes;
  final List<LookupItemEntity> propertyFeatures;
  final List<LookupItemEntity> governates;
  final SearchFilter currentFilter;
  final List<RecentSearch> recentSearches;

  const LookupsLoaded({
    required this.propertyTypes,
    required this.propertyFeatures,
    required this.governates,
    required this.currentFilter,
    required this.recentSearches,
  });

  @override
  List<Object?> get props => [
        propertyTypes,
        propertyFeatures,
        governates,
        currentFilter,
        recentSearches,
      ];
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<PropertyEntity> properties;
  final int totalCount;
  final SearchFilter currentFilter;
  final List<LookupItemEntity> propertyTypes;
  final List<LookupItemEntity> propertyFeatures;
  final List<LookupItemEntity> governates;
  final List<RecentSearch> recentSearches;
  final bool hasReachedMax;

  const SearchLoaded({
    required this.properties,
    required this.totalCount,
    required this.currentFilter,
    required this.propertyTypes,
    required this.propertyFeatures,
    required this.governates,
    required this.recentSearches,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
        properties,
        totalCount,
        currentFilter,
        propertyTypes,
        propertyFeatures,
        governates,
        recentSearches,
        hasReachedMax,
      ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

class RecentSearch extends Equatable {
  final String? location;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;
  final DateTime timestamp;

  const RecentSearch({
    this.location,
    this.checkIn,
    this.checkOut,
    this.guests,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [location, checkIn, checkOut, guests, timestamp];

  Map<String, dynamic> toJson() => {
        'location': location,
        'checkIn': checkIn?.millisecondsSinceEpoch,
        'checkOut': checkOut?.millisecondsSinceEpoch,
        'guests': guests,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
        location: json['location'] as String?,
        checkIn: json['checkIn'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['checkIn'] as int)
            : null,
        checkOut: json['checkOut'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['checkOut'] as int)
            : null,
        guests: json['guests'] as int?,
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}
