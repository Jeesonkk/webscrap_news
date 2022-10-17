import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_roll_out/resource/Repository.dart';

part 'newscontentproviderbloc_event.dart';
part 'newscontentproviderbloc_state.dart';

class NewscontentproviderblocBloc
    extends Bloc<NewscontentproviderblocEvent, NewscontentproviderblocState> {
  NewscontentproviderblocBloc() : super(NewscontentproviderblocInitial()) {
    on<newsloaded>(_loadingnewscontent);
  }

  Future _loadingnewscontent(
      newsloaded event, Emitter<NewscontentproviderblocState> emit) async {
    try {
      List newscontent =
          await Repository().newscontentprovider(type: event.type);
      emit(Newscontentproviderblocloaded(newscontent));
    } catch (e) {}
    return [];
  }
}
