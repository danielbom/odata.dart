import 'dart:convert';

import 'package:odata/odata_requester.dart';
import 'package:http/http.dart' as http;

class ODataHttpRequester extends ODataRequester {
  final String baseUrl;
  final Map<String, String> headers;
  final JsonEncoder encoder = const JsonEncoder();

  const ODataHttpRequester({
    required this.baseUrl,
    this.headers = const {},
  });

  @override
  Future<RequestResult> httpGet(String url, [RequestOptions? options]) async {
    final headers = _makeHeaders(options);
    final completeUrl = _makeUrl(url, options);
    final response = await http.get(Uri.parse(completeUrl), headers: headers);
    return _mapResponse(completeUrl, response);
  }

  @override
  Future<RequestResult> httpPost<T>(String url, T data,
      [RequestOptions? options]) async {
    final headers = _makeHeaders(options);
    final completeUrl = _makeUrl(url, options);
    final body = toJson(data);
    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: body);
    return _mapResponse(completeUrl, response);
  }

  @override
  Future<RequestResult> httpPatch<T>(String url, T data,
      [RequestOptions? options]) async {
    final headers = _makeHeaders(options);
    final completeUrl = _makeUrl(url, options);
    final body = toJson(data);
    final response = await http.patch(Uri.parse(completeUrl), headers: headers, body: body);
    return _mapResponse(completeUrl, response);
  }

  @override
  Future<RequestResult> httpPut<T>(String url, T data,
      [RequestOptions? options]) async {
    final headers = _makeHeaders(options);
    final completeUrl = _makeUrl(url, options);
    final body = toJson(data);
    final response = await http.put(Uri.parse(url), headers: headers, body: body);
    return _mapResponse(completeUrl, response);
  }

  @override
  Future<RequestResult> httpDelete(String url,
      [RequestOptions? options]) async {
    final headers = _makeHeaders(options);
    final completeUrl = _makeUrl(url, options);
    final response = await http.delete(Uri.parse(completeUrl), headers: headers);
    return _mapResponse(completeUrl, response);
  }

  @override
  Future<RequestResult> httpOptions(String url,
      [RequestOptions? options]) async {
    throw UnimplementedError();
  }

  String toJson(dynamic data) {
    return encoder.convert(data);
  }

  Map<String, String> _makeHeaders(RequestOptions? options) {
    final headers = { 'Content-Type': 'application/json' }
      ..addAll(this.headers)
      ..addAll(options?.headers ?? {});
    
    return headers;
  }

  String _makeUrl(String url, RequestOptions? options) {
    final params = _makeParams(options);
    return '$baseUrl$url$params';
  }

  String _makeParams(RequestOptions? options) {
    final params = options?.buildParams();
    if (params != null && params.isNotEmpty) {
      return '?' + params;
    } else {
      return '';
    }
  }

  RequestResult _mapResponse(String url, http.Response response) {
    return RequestResultBase(
      url: url,
      statusCode: response.statusCode,
      data: response.body,
    );
  }
}
