part of 'internet_cubit.dart';

abstract class InternetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InternetInitial extends InternetState {}

class InternetConnected extends InternetState {}

class InternetDisconnected extends InternetState {}