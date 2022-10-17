import 'package:news_roll_out/resource/exceptions.dart';
import 'package:news_roll_out/resource/rest_api.dart';

class NewsContentApiProvider {
  String getType({required String type /*, int page, int perPageCount*/
      }) {
    //   String pagination;
    //  page != null ? pagination = "&page=$page&perPageCount=$perPageCount" : pagination = "";
    switch (type) {
      case "manorama":
        return 'https://www.manoramanews.com/';
      case "twenty_four":
        return 'https://www.twentyfournews.com/';
      default:
        return '';
    }
  }

  Future<List> newscontentProvider(String type) async {
    try {
      final response = await RestApi().getnews(getType(type: type));
      if (getType(type: type) == 'https://www.manoramanews.com/') {
        var responseString1 = response
            .getElementsByClassName('image-overlay-bottomn')[0]
            .children[1]
            .children[0];
        var responseimage1 = response
            .getElementsByClassName('image-main')[0]
            .getElementsByClassName('lazyload')[0]
            .attributes['data-src'];
        print('$responseString1....1$responseString1');
        return [responseString1, responseimage1];
      } else if (getType(type: type) == 'https://www.twentyfournews.com/') {
        var responseString =
            response.getElementsByClassName('dtItle HeadingMain2').first;
        var responseimage = response
            .getElementsByClassName('main-post-img relative')
            .first
            .getElementsByClassName('lazy')[0]
            .attributes['data-src'];
        print('${responseString.text.trim()}....$responseimage');
        return [responseString, responseimage];
      }
    } on Errorexceptios catch (e) {
      print(e);
    }
    return [];
  }
}
