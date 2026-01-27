part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;

  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileState {
  final String errorMsg;

  ProfileError(this.errorMsg);
}
