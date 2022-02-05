import 'package:odata/odata_requester.dart';

import 'dart:convert';

class RequesterFaker implements ODataRequester {
  final String baseUrl;
  final dynamic data;
  final dynamic error;
  final int statusCode;

  const RequesterFaker(
      {this.statusCode = 200, this.baseUrl = '', this.data, this.error});

  @override
  Future<RequestResult> httpOptions(String url, [RequestOptions? options]) async {
    return RequestResultBase(
        data: data, error: error, statusCode: statusCode, url: url);
  }

  @override
  Future<RequestResult> httpGet(String url, [RequestOptions? options]) async {
    var params = options?.buildParams() ?? '';
    if (params.isNotEmpty) {
      params = '?$params';
    }

    return RequestResultBase(
        url: baseUrl + url + params,
        data: jsonEncode(data),
        statusCode: statusCode);
  }

  @override
  Future<RequestResult> httpPost<D>(String url, D data,
      [RequestOptions? options]) async {
    return RequestResultBase(
        data: jsonEncode(this.data), error: error, statusCode: statusCode, url: url);
  }

  @override
  Future<RequestResult> httpPut<T>(String url, T data,
      [RequestOptions? options]) async {
    return RequestResultBase(
        data: this.data, error: error, statusCode: statusCode, url: url);
  }

  @override
  Future<RequestResult> httpPatch<T>(String url, T data,
      [RequestOptions? options]) async {
    return RequestResultBase(
        data: this.data, error: error, statusCode: statusCode, url: url);
  }

  @override
  Future<RequestResult> httpDelete(String url,
      [RequestOptions? options]) async {
    return RequestResultBase(
        data: data, error: error, statusCode: statusCode, url: url);
  }
}
