part of 'misc_bloc.dart';

sealed class MiscEvent extends Equatable {
  const MiscEvent();

  @override
  List<Object> get props => [];
}

final class MiscDataRequested extends MiscEvent {}
