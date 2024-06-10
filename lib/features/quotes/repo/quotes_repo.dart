import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:openai_app/constants.dart';
import 'package:openai_app/features/quotes/model/Open_ai_model.dart';

class QuotesRepo{
  static GetQuotesAPI() async{
    var client = http.Client();
    try {
      final body = {
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "user", "content":"get one random life quote"}], 
        "max_tokens": 100,
        "temperature": 1,
      };
      final jsonString = json.encode(body);
      final uri = Uri.https(ApiConstants.baseUrl,ApiConstants.params);
      final headers = {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader:'Bearer '};
      final response = await client.post(uri, headers: headers, body: jsonString);

      print('-------------');
      print(response.body.toString());

      OpenAiRes resp = openAiResFromJson(response.body.toString());

      return resp;
      
    } catch (e) {
      print(e.toString());
    }
  }
}