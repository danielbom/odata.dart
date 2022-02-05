library odata;

import 'odata_result.dart';
import 'odata_requester.dart';
import 'odata_source.dart';
import 'odata_params.dart';

abstract class ODataSourceMapper<T> {
  const ODataSourceMapper();

  T mapOne(Map<String, dynamic> data);
  List<T> mapMany(List<Map<String, dynamic>> data);
}

class ODataSourceMapped<T> {
  final ODataSource source;
  final ODataSourceMapper<T> mapper;

  const ODataSourceMapped(this.source, this.mapper);

  factory ODataSourceMapped.create(
      {required ODataRequester requester,
      required String entity,
      required ODataSourceMapper<T> mapper,
      String odataPrefix = '/odata.v1'}) {
    return ODataSourceMapped(
        ODataSource(
            entity: entity, requester: requester, odataPrefix: odataPrefix),
        mapper);
  }

  Future<RequestOData<List<T>>> list(
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.list(
        options: options, params: params, params1: params1, mapper: mapMany);
  }

  Future<RequestOData<T>> getById(String id,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.getById(id,
        options: options, params: params, params1: params1, mapper: mapOne);
  }

  Future<RequestOData<T>> create<D>(D data,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.create(data,
        options: options, params: params, params1: params1, mapper: mapOne1);
  }

  Future<RequestOData<T>> update<D>(String id, D data,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.update(id, data,
        options: options, params: params, params1: params1, mapper: mapOne1);
  }

  Future<RequestOData<T>> replace<D>(String id, D data,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.replace(id, data,
        options: options, params: params, params1: params1);
  }

  Future<RequestOData<dynamic>> delete<T>(String id,
      {RequestOptions? options}) async {
    return source.delete(id, options: options);
  }

  T mapOne(Map<String, dynamic> data) {
    return mapper.mapOne(ODataSource.getValueAsMap(data));
  }

  T mapOne1(Map<String, dynamic> data) {
    return mapper.mapOne(data);
  }

  List<T> mapMany(Map<String, dynamic> data) {
    return mapper.mapMany(ODataSource.getValueAsList(data));
  }
}
