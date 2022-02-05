library odata;

class RequestOptions {
  final Map<String, String>? params;
  final Map<String, String>? headers;

  const RequestOptions({this.params, this.headers});

  String buildParams() {
    return params
            ?.map((key, value) => MapEntry(key, '$key=$value'))
            .values
            .join('&') ??
        '';
  }
}

class RequestResultBase<T> {
  final T? data;
  final Error? error;
  final int? statusCode;
  final String? url;

  const RequestResultBase({this.data, this.error, this.statusCode, this.url});

  RequestResultBase<K> map<K>(K Function(T? data) mapper) {
    return RequestResultBase(
      error: error,
      statusCode: statusCode,
      url: url,
      data: mapper(data),
    );
  }
}

typedef RequestResult = RequestResultBase<String>;

abstract class ODataRequester {
  const ODataRequester();

  Future<RequestResult> httpOptions(String url, [RequestOptions? options]);
  Future<RequestResult> httpGet(String url, [RequestOptions? options]);
  Future<RequestResult> httpPost<T>(String url, T data,
      [RequestOptions? options]);
  Future<RequestResult> httpPut<T>(String url, T data,
      [RequestOptions? options]);
  Future<RequestResult> httpPatch<T>(String url, T data,
      [RequestOptions? options]);
  Future<RequestResult> httpDelete(String url, [RequestOptions? options]);
}
