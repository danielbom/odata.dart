library odata;

import 'dart:convert';

import 'odata_result.dart';
import 'odata_exception.dart';
import 'odata_requester.dart';
import 'odata_params.dart';

typedef ODataMap<T> = T Function(Map<String, dynamic>);

class ODataSource {
  final String odataPrefix;
  final ODataRequester requester;
  final String entity;

  const ODataSource(
      {required this.requester,
      required this.entity,
      this.odataPrefix = '/odata.v1'});

  Future<RequestOData<List<T>>> list<T>(
      {ODataMap<List<T>>? map,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(params1: params1, params: params);
    final request = await requester.httpGet(url, options);
    return _mapODataResult(map, request);
  }

  Future<RequestOData<T>> getById<T>(String id,
      {ODataMap<T>? map,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(id: id, params1: params1, params: params);
    final result = await requester.httpGet(url, options);
    return _mapODataResult(map, result);
  }

  Future<RequestOData<T>> create<D, T>(D data,
      {ODataMap<T>? map,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = _makeUrl(params1: params1, params: params);
    final result = await requester.httpPost(url, data, options);
    return _mapODataResult(map, result);
  }

  Future<RequestOData> update<D>(String id, D data,
      {RequestOptions? options}) async {
    final url = _makeUrl1(id);
    final result = await requester.httpPatch(url, data, options);
    return _mapODataResult1(result);
  }

  Future<RequestOData> replace<D>(String id, D data,
      {RequestOptions? options}) async {
    final url = _makeUrl1(id);
    final result = await requester.httpPut(url, data, options);
    return _mapODataResult1(result);
  }

  Future<RequestOData> delete(String id, {RequestOptions? options}) async {
    final url = _makeUrl1(id);
    final result = await requester.httpDelete(url, options);
    return _mapODataResult1(result);
  }

  RequestOData<T> _mapODataResult<T>(
      ODataMap<T>? map, RequestResult request) {
    return request.map((data) {
      final Map<String, dynamic> decodedData = jsonDecode(data!);
      if (ODataResult.isError(decodedData)) {
        throw ODataException.fromJson(decodedData);
      } else if (map != null) {
        return ODataResult.mapped(decodedData, map);
      } else {
        return ODataResult.raw(decodedData);
      }
    });
  }

  RequestOData<T> _mapODataResult1<T>(RequestResult request) {
    return request.map((data) {
      final Map<String, dynamic> decodedData = jsonDecode(data!);
      if (ODataResult.isError(decodedData)) {
        throw ODataException.fromJson(decodedData);
      } else {
        return ODataResult.raw(decodedData);
      }
    });
  }

  String _makeUrl({String id = '', Params? params, String? params1}) {
    if (id.isNotEmpty) id = '($id)';
    var params2 = params1 ?? '';
    var params3 = params != null ? params.toString() : '';
    var querySep = params2.isNotEmpty || params3.isNotEmpty ? '?' : '';
    var paramsSep = params2.isNotEmpty && params3.isNotEmpty ? '&' : '';
    return '$odataPrefix/$entity$id$querySep$params2$paramsSep$params3';
  }

  String _makeUrl1(String id) {
    return '$odataPrefix/$entity($id)';
  }

  static List<Map<String, dynamic>> getValueAsList(Map<String, dynamic> data) {
    return List.from(data[ODATA_VALUE]);
  }

  static Map<String, dynamic> getValueAsMap(Map<String, dynamic> data) {
    return Map.from(data[ODATA_VALUE]);
  }
}
