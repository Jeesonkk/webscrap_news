import 'dart:convert';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:news_roll_out/resource/exceptions.dart';

class RestApi {
  Future<T> getnews<T>(String url, [String t = '']) async {
    T responseJson = _returnResponse('');
    try {
      Response response = await http.Client().get(Uri.parse(url));
      responseJson = _returnResponse(response);
    } catch (e) {
      print(e);
    }
    return responseJson;
  }

  _returnResponse<T>(T response) {
    if (response is http.Response) {
      switch (response.statusCode) {
        case 200:
          var responseJson = parser.parse(response.body);
          print("responseJson : ${responseJson.body}");

          return responseJson;
        case 404:
          //throw  FetchDataErrorException(json.decode(response.body));
          //throw BadRequestException(json.decode(response.body));

          throw BadRequestException(json.decode(response.body));

        case 400:
          throw BadRequestException(json.decode(response.body));
        case 401:

        case 403:
          throw UnauthorisedException(json.decode(response.body));
        case 500:
          /* default:
        GlobalWidgets().showToast(msg: CoupledStrings.serverDown);*/
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    }
  }
}
