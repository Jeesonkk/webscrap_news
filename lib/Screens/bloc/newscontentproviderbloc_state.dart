part of 'newscontentproviderbloc_bloc.dart';

abstract class NewscontentproviderblocState extends Equatable {
  const NewscontentproviderblocState([props]) : super();
}

class NewscontentproviderblocInitial extends NewscontentproviderblocState {
  @override
  List<Object> get props => [];
}

class Newscontentproviderblocloaded extends NewscontentproviderblocState {
  List newscontent;
  Newscontentproviderblocloaded(this.newscontent);
  @override
  List<Object> get props => [newscontent];
}
