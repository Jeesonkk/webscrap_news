import 'package:news_roll_out/resource/newsprovvider.dart';

class Repository {
  final getcontentprovider = NewsContentApiProvider();
  Future<List> newscontentprovider({required String type}) =>
      getcontentprovider.newscontentProvider(type);
}
