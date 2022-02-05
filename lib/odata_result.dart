library odata;

import 'package:odata/odata.dart';

import 'odata_requester.dart';

const ODATA_COUNT = '@odata.count';
const ODATA_CONTEXT = '@odata.context';
const ODATA_VALUE = 'value';
const ODATA_KEYS = 'keys';
const ODATA_PROPERTIES = 'properties';

class ODataResult<T> {
  final List<String> keys;
  final String context;
  final Map<String, String> properties;
  final int? count;

  final T? value;
  final Map<String, dynamic>? raw;

  const ODataResult({
    required this.context,
    this.value,
    this.keys = const [],
    this.properties = const {},
    this.count,
    this.raw,
  });

  factory ODataResult.mapped(Map<String, dynamic> data, ODataMapper<T> mapper) {
    return ODataResult(
      context: data[ODATA_CONTEXT],
      value: mapper(data),
      count: data[ODATA_COUNT],
      keys: data[ODATA_KEYS] ?? const [],
      properties: data[ODATA_PROPERTIES] ?? const {},
    );
  }

  factory ODataResult.raw(Map<String, dynamic> data) {
    return ODataResult(
      context: data[ODATA_CONTEXT],
      raw: data,
      count: data[ODATA_COUNT],
      keys: data[ODATA_KEYS] ?? const [],
      properties: data[ODATA_PROPERTIES] ?? const {},
    );
  }

  static bool isError(Map<String, dynamic> data) {
    return data[ODATA_CONTEXT] == null;
  }
}

typedef RequestOData<T> = RequestResultBase<ODataResult<T>>;
