library odata;

import 'odata_result.dart';
import 'odata_requester.dart';
import 'odata_source.dart';
import 'odata_params.dart';
import 'odata_mapper.dart';

class ODataSourceMapped<T> {
  final ODataSource source;
  final ODataMapper<T> mapper;

  const ODataSourceMapped(this.source, this.mapper);

  factory ODataSourceMapped.create(
      {required ODataRequester requester,
      required String entity,
      required ODataMapper<T> mapper,
      String odataPrefix = '/odata.v1'}) {
    return ODataSourceMapped(
        ODataSource(
            entity: entity, requester: requester, odataPrefix: odataPrefix),
        mapper);
  }

  Future<RequestOData<List<T>>> list(
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.list(
        options: options, params: params, params1: params1, map: mapper.mapMany1);
  }

  Future<RequestOData<T>> getById(String id,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.getById(id,
        options: options, params: params, params1: params1, map: mapper.mapOne);
  }

  Future<RequestOData<T>> create<D>(D data,
      {RequestOptions? options, Params? params, String? params1}) async {
    return source.create(data,
        options: options, params: params, params1: params1, map: mapper.mapOne);
  }

  Future<RequestOData> update<D>(String id, D data,
      {RequestOptions? options}) async {
    return source.update(id, data, options: options);
  }

  Future<RequestOData> replace<D>(String id, D data,
      {RequestOptions? options}) async {
    return source.replace(id, data, options: options);
  }

  Future<RequestOData> delete(String id, {RequestOptions? options}) async {
    return source.delete(id, options: options);
  }
}
