part of 'newscontentproviderbloc_bloc.dart';

abstract class NewscontentproviderblocEvent extends Equatable {
  const NewscontentproviderblocEvent();

  @override
  List<Object> get props => [];
}

class newsloading extends NewscontentproviderblocEvent {}

class newsloaded extends NewscontentproviderblocEvent {
  String type;
  newsloaded({required this.type});
  @override
  List<Object> get props => [type];
}
