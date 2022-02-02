import 'odata_requester.dart';

class ODataResult<T> {
  final List<String> keys;
  final String context;
  final Map<String, String> properties;
  final int? count;
  final T? value;
  final String? raw;

  const ODataResult({
    required this.context,
    this.value,
    this.keys = const [],
    this.properties = const {},
    this.count,
    this.raw,
  });
}

typedef RequestOData<T> = RequestResultBase<ODataResult<T>>;
