library odata;

import 'dart:convert';

import 'odata_requester.dart';
import 'odata_params.dart';

typedef ODataResultOne = Map<String, dynamic>;
typedef ODataMapper<T> = T Function(Map<String, dynamic>);

typedef ODataRawResult = Map<String, dynamic>;

class ODataResult<T> {
  final List<String> keys;
  final String context;
  final Map<String, String> properties;
  final int? count;
  final T? value;
  final String? data;

  const ODataResult({
    required this.context,
    this.value,
    this.keys = const [],
    this.properties = const {},
    this.count,
    this.data,
  });
}

typedef RequestOData<T> = RequestResultBase<ODataResult<T>>;

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
    final url = '$odataPrefix/$entity${params1 ?? ''}${_processParams(params)}';
    final request = await requester.httpGet(url, options);
    return _mapODataResult(mapper, request);
  }

  Future<RequestOData<T>> getById<T>(String id,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url =
        '$odataPrefix/$entity($id)${params1 ?? ''}${_processParams(params)}';
    final result = await requester.httpGet(url, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> create<D, T>(D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = '$odataPrefix/$entity${params1 ?? ''}${_processParams(params)}';
    final result = await requester.httpPost(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> update<D, T>(D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = '$odataPrefix/$entity${params1 ?? ''}${_processParams(params)}';
    final result = await requester.httpPatch(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> replace<D, T>(D data,
      {ODataMapper<T>? mapper,
      RequestOptions? options,
      Params? params,
      String? params1}) async {
    final url = '$odataPrefix/$entity${params1 ?? ''}${_processParams(params)}';
    final result = await requester.httpPut(url, data, options);
    return _mapODataResult(mapper, result);
  }

  Future<RequestOData<T>> delete<T>(String id,
      {ODataMapper<T>? mapper, RequestOptions? options}) async {
    final url = '$odataPrefix/$entity($id)';
    final result = await requester.httpDelete(url);
    return _mapODataResult(mapper, result);
  }

  RequestOData<T> _mapODataResultDefault<T>(RequestResult request) {
    return request.map((data) => ODataResult(context: '', data: data));
  }

  RequestOData<T> _mapODataResult<T>(
      ODataMapper<T>? mapper, RequestResult request) {
    if (mapper == null) {
      return _mapODataResultDefault(request);
    }

    try {
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
    } catch (error) {
      rethrow;
    } finally {
      return _mapODataResultDefault(request);
    }
  }

  String _processParams(Params? params) {
    return params != null ? '?$params' : '';
  }

  static List<ODataRawResult> getValueAsList(ODataRawResult data) {
    return List.from(data[ODATA_VALUE]);
  }

  static ODataRawResult getValueAsMap(ODataRawResult data) {
    return Map.from(data[ODATA_VALUE]);
  }
}
