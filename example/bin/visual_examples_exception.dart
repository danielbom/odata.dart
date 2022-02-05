import 'package:odata/odata.dart';

void exceptionVisualTest() {
  const exception = ODataException(
      type: 'https://tools.ietf.org/html/rfc7231#section-6.6.1',
      traceId: '00-e675d7e4871b3943b4c0bd5abde9e16b-6103ca2b8d53a64d-00',
      status: 500,
      title: 'An error occurred while processing your request.',
      detail: 'Object reference not set to an instance of an object.');
  print('');
  print(exception);
}
