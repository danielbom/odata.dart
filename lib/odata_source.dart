library odata;

import 'dart:convert';

import 'odata_result.dart';
import 'odata_requester.dart';
import 'odata_params.dart';

typedef ODataMapper<T> = T Function(Map<String, dynamic>);

const ODATA_COUNT = '@odata.count';
const ODATA_CONTEXT = '@odata.context';
const ODATA_VALUE = 'value';
const ODATA_KEYS = 'keys';
const ODATA_PROPERTIES = 'properties';

class ODataSource {
  final String odataPrefix;
  final ODataRequester requester;
  final String entity;

  const ODataSource(
      {required this.requester,
      required this.entity,
      this.odataPrefix = '/odata.v1'});

  Future<RequestOData<List<T>>> list<T>(
      {ODataMapper<List<T>>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(params1: params1, params: params);
    final request = await requester.httpGet(url, options);
    return _mapODataResult(mapper, request);
  }

  Future<RequestOData<T>> getById<T>(String id,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(id: id, params1: params1, params: params);
    final result = await requester.httpGet(url, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> create<D, T>(D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(params1: params1, params: params);
    final result = await requester.httpPost(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> update<D, T>(String id, D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(id: id, params1: params1, params: params);
    final result = await requester.httpPatch(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> replace<D, T>(String id, D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(id: id, params1: params1, params: params);
    final result = await requester.httpPut(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<dynamic>> delete<T>(String id,
      {RequestOptions? options}) async {
    final url = _makeUrl(id: id);
    final result = await requester.httpDelete(url, options);
    return _mapODataResult(null, result);
  }

  RequestOData<T> _mapODataResult<T>(
      ODataMapper<T>? mapper, RequestResult request) {
    if (mapper == null) {
      return request.map((data) => ODataResult(context: '', raw: data));
    }

    return request.map((data) {
      final Map<String, dynamic> decodedData = jsonDecode(data!);
      return ODataResult(
        context: decodedData[ODATA_CONTEXT],
        value: mapper(decodedData),
        count: decodedData[ODATA_COUNT],
        keys: decodedData[ODATA_KEYS] ?? const [],
        properties: decodedData[ODATA_PROPERTIES] ?? const {},
      );
    });
  }

  String _makeUrl({String id = '', Params? params, String? params1}) {
    if (id.isNotEmpty) id = '($id)';
    return '$odataPrefix/$entity$id${params1 ?? ""}${_processParams(params)}';
  }

  String _processParams(Params? params) {
    return params != null ? '?$params' : '';
  }

  static List<Map<String, dynamic>> getValueAsList(Map<String, dynamic> data) {
    return List.from(data[ODATA_VALUE]);
  }

  static Map<String, dynamic> getValueAsMap(Map<String, dynamic> data) {
    return Map.from(data[ODATA_VALUE]);
  }
}
