part of 'friends_bloc.dart';

sealed class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

final class FriendsRequested extends FriendsEvent {
  final String subCategory;
  final LocationFilterType locationFilterType;
  final Address userAddress;

  const FriendsRequested({
    required this.subCategory,
    required this.locationFilterType,
    required this.userAddress,
  });

  @override
  List<Object> get props => [
        subCategory,
        locationFilterType,
        userAddress,
      ];
}
