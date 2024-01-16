import 'package:equatable/equatable.dart';

abstract class ProfileCompletionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileCompletionDataRequested extends ProfileCompletionEvent {
  ProfileCompletionDataRequested();
}
