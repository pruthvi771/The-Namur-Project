import 'package:equatable/equatable.dart';

abstract class ProfileCompletionState extends Equatable {}

final class ProfileCompletionDataReceived extends ProfileCompletionState {
  final double profileProgress;

  ProfileCompletionDataReceived({
    required this.profileProgress,
  });

  @override
  List<Object?> get props => [profileProgress];
}

final class ProfileCompletionLoading extends ProfileCompletionState {
  @override
  List<Object?> get props => [];
}
