library odata;

const ODATA_TYPE = 'type';
const ODATA_TITLE = 'title';
const ODATA_STATUS = 'status';
const ODATA_DETAIL = 'detail';
const ODATA_TRACEID = 'traceId';

class ODataException implements Exception {
  final String type;
  final String title;
  final int status;
  final String detail;
  final String traceId;

  const ODataException({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    required this.traceId,
  });

  factory ODataException.fromJson(Map<String, dynamic> data) {
    return ODataException(
      type: data[ODATA_TYPE],
      title: data[ODATA_TITLE],
      status: data[ODATA_STATUS],
      detail: data[ODATA_DETAIL],
      traceId: data[ODATA_TRACEID],
    );
  }

  @override
  String toString() {
    return 'ODataException'
        '\n  title:   $title'
        '\n  detail:  $detail'
        '\n  status:  $status'
        '\n  traceId: $traceId'
        '\n  type:    $type';
  }
}
