import 'package:odata/odata_requester.dart';

import 'dart:convert';

class RequesterFaker implements ODataRequester {
  final String baseUrl;
  const RequesterFaker({this.baseUrl = ''});

  @override
  Future<RequestResult> httpOptions(String url, [RequestOptions? options]) {
    throw UnimplementedError();
  }

  @override
  Future<RequestResult> httpGet(String url, [RequestOptions? options]) async {
    var params = options?.buildParams() ?? '';
    if (params.isNotEmpty) {
      params = '?$params';
    }

    return RequestResultBase(
        url: baseUrl + url + params,
        value: jsonEncode(const {
          '@odata.context': 'fake_context',
          'value': [
            {'Id': '1', 'Width': 100, 'Height': 31, 'Sides': [], 'Parent': {}},
            {
              'Id': '1',
              'Width': 48,
              'Height': 21,
              'Sides': null,
              'Parent': null
            }
          ]
        }),
        statusCode: 200);
  }

  @override
  Future<RequestResult> httpPost<T>(String url, T data,
      [RequestOptions? options]) {
    throw UnimplementedError();
  }

  @override
  Future<RequestResult> httpPut<T>(String url, T data,
      [RequestOptions? options]) {
    throw UnimplementedError();
  }

  @override
  Future<RequestResult> httpPatch<T>(String url, T data,
      [RequestOptions? options]) {
    throw UnimplementedError();
  }

  @override
  Future<RequestResult> httpDelete(String url, [RequestOptions? options]) {
    throw UnimplementedError();
  }
}
