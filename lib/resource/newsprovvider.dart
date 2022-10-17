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
        //headlines
        //head1
        String class1news = 'image-overlay-bottomn';
        String imgclass1 = 'image-main';
        String imgclass2 = 'lazyload';
        String attribute = 'data-src';
        //Latestnews
        //Latest1
        String classlatestnes = 'news-list-ml';
        var responseString1 = response
            .getElementsByClassName(class1news)[0]
            .children[1]
            .children[0];
        var responseimage1 = response
            .getElementsByClassName(imgclass1)[0]
            .getElementsByClassName(imgclass2)[0]
            .attributes[attribute];
        var responselatestnewsString1 = response
            .getElementsByClassName('story-list-2')[0]
            .getElementsByClassName(class1news)[0]
            .getElementsByTagName('a')[0];
        var responselatestimage1 = response
            .getElementsByClassName('story-list-2')[0]
            .getElementsByClassName(imgclass1)[0]
            .getElementsByClassName(imgclass2)[0]
            .attributes[attribute];
        print(
            '$responseString1....1$responseString1${responselatestnewsString1}$responselatestimage1');
        return [
          responseString1,
          responseimage1,
          responselatestnewsString1,
          responselatestimage1
        ];
      } else if (getType(type: type) == 'https://www.twentyfournews.com/') {
        //headlines
        //head1
        String class1news = 'dtItle HeadingMain2';
        String imgclass1 = 'main-post-img relative';
        String imgclass2 = 'lazy';
        String attribute = 'data-src';
        //latestnews
        //1
        String classlatesthead = 'row spost-img mbtm20';
        String classlatesthead1 = 'dtItle HeadingSec';
        String classimage = 'lazy mbtm15';
        String attributelatestimg = 'data-src';
        //Sports
        String spotsclass = 'keralaNews prite30';
        String sportsclass2 = 'dtItle HeadingMain mtop20';
        //head1
        var responseString = response.getElementsByClassName(class1news).first;
        var responseimage = response
            .getElementsByClassName(imgclass1)
            .first
            .getElementsByClassName(imgclass2)[0]
            .attributes[attribute];

        print('${responseString.text.trim()}....$responseimage');

        //latest1

        var latestnewsimage = response
            .getElementsByClassName(classlatesthead)[0]
            .getElementsByTagName('amp-img')[0]
            .attributes['src'];
        print('latestimage....$latestnewsimage');
        var latestnewsnews = response
            .getElementsByClassName(classlatesthead)[0]
            .getElementsByClassName('dtItle HeadingSec')[0];
        print(latestnewsnews.text);
        // print('laestnews..${latestnewsnews.text}...${latestnewsimage}');
        //Sports
        // var sportslatestnews =
        //     response.getElementByClassName(spotsclass).attributes;

        // print('....$sportslatestnews');
        return [responseString, responseimage, latestnewsnews, latestnewsimage];
      }
    } on Errorexceptios catch (e) {
      print(e);
    }
    return [];
  }
}
