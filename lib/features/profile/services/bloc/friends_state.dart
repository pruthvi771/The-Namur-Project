part of 'friends_bloc.dart';

sealed class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

final class FriendsInitial extends FriendsState {}

final class FriendsLoadInProgress extends FriendsState {}

final class FriendsLoadSuccess extends FriendsState {
  final List<SellerGroupItem> sellers;

  const FriendsLoadSuccess({
    required this.sellers,
  });

  @override
  List<Object> get props => [sellers];
}
